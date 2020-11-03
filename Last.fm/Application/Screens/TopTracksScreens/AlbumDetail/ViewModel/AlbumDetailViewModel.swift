//
//  AlbumDetailViewModel.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/15/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailViewModel {
    var validAlbumDetailDataSource = ValidAlbumDetailInfo(songCount: "0", totalAlbumTimeDuration: "0", headShot: UIImage(), url: "")
    var validAlbumTrackdetailDataSource = [ValidAlbumTrackDetailInfo]()
    var searchedSongList = [SearchedInfo]()
    
    func parseAlbumDetailData(artist: String, albumName: String, aSimplehandler handler: @escaping (Error?) -> Void) {
        let paraDictionary = [
            "artist": artist,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "method": "album.getInfo",
            "format": AppConstants.LastFMAPI.format,
            "album": albumName
        ]
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: paraDictionary) { data, error in
            guard let data = data else { return }
            var totalDuration = 0
            do {
                let json = try JSONDecoder().decode(AlbumDetailModel.self, from: data)
                guard let tracks = json.album?.tracks?.track else { return }
                for track in tracks {
                    if let name = track.name,
                       let singerInfo = track.artist,
                       let singerName = singerInfo["name"],
                        let duration = track.duration,
                        let durationInt = Int(duration) {
                            let durationMinute = durationInt / 60
                            let durationSec = durationInt % 60
                            let timeString = durationSec < 10 ? "\(durationMinute):0\(durationSec)" : "\(durationMinute):\(durationSec)"
                            let singleTrack = ValidAlbumTrackDetailInfo(trackName: name, trackDuration: timeString, singer: singerName)
                            self.validAlbumTrackdetailDataSource.append(singleTrack)
                            totalDuration += durationInt
                    }
                }
                self.validAlbumDetailDataSource = ValidAlbumDetailInfo(songCount: "0", totalAlbumTimeDuration: "0", headShot: UIImage(), url: "")
                if let imageString = json.album?.image?[3]["#text"],
                   let albumUrl = json.album?.url {
                    var headShotAlbumImge = UIImage()
                    if let url = URL(string: imageString) {
                        let headShotData = try Data(contentsOf: url)
                        headShotAlbumImge = UIImage(data: headShotData) ?? UIImage()
                    } else {
                        headShotAlbumImge = UIImage(imageLiteralResourceName: AppConstants.ImageName.unfetchedImageName)
                    }
                    self.validAlbumDetailDataSource = ValidAlbumDetailInfo(songCount: String(tracks.count),
                                                                           totalAlbumTimeDuration: String(totalDuration / 60),
                                                                           headShot: headShotAlbumImge,
                                                                           url: albumUrl)
                }
                handler(nil)
            } catch { handler(error) }
        }
    }
    
    func parseSearchedResults(searchQuery: String, aSimpleHnadler handler: @escaping ([SearchedInfo]?) -> Void ) {
        searchedSongList = [SearchedInfo]()
        let paraDictionary = [
            "api_key": AppConstants.LastFMAPI.apiKey,
            "method": AppConstants.LastFMAPIMethod.search,
            "format": AppConstants.LastFMAPI.format,
            "track": searchQuery
        ]
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: paraDictionary) { data, error in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(SearchedResults.self, from: data)
                guard let searchedSongList = json.results?.trackMatches?.track else { return }
                for song in searchedSongList {
                    if let songName = song.name {
                        let searchedSong = SearchedInfo(name: songName)
                        self.searchedSongList.append(searchedSong)
                    }
                }
                handler(searchedSongList)
            } catch { print("error in parsing", error.localizedDescription) }
        }
    }
}
