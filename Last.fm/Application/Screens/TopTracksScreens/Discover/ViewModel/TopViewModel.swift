//
//  TopViewModel.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 8/17/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class TopViewModel {
    var topSongList = [TopSongModel]()
    var popularSongList = [PopularSongModel]()
    var searchedSongList = [SearchedInfo]()
    let baseUrlString = AppConstants.LastFMAPI.apiRootUrl
    let backUpImage = UIImage(imageLiteralResourceName: AppConstants.ImageName.unfetchedImageName)
    
    func parseTopSongs(aSimpleHandler handler: @escaping (Error?) -> Void) {
        let paraDictionary = [
            "track": AppConstants.LastFMAPI.trackBackUp,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "method": AppConstants.LastFMAPIMethod.getSimiliar,
            "format": AppConstants.LastFMAPI.format,
            "artist": AppConstants.LastFMAPI.singerBackUp
        ]
        Service.shared.fetchData(url: baseUrlString, parameters: paraDictionary) { data, error in
            do {
                guard let data = data else { return }
                let json = try JSONDecoder().decode(MainTopSongModel.self, from: data)
                guard let songlists = json.similartracks?.track else { return }
                for song in songlists {
                     if let songName = song.name,
                        let artistName = song.artist?["name"],
                        let headShotString = song.image?.first?["#text"] {
                        do {
                            guard let url = URL(string: headShotString) else { return }
                            let headShotData = try Data(contentsOf: url)
                            if let headShotImage = UIImage(data: headShotData) {
                                let topSong = TopSongModel(headShot: headShotImage, singer: artistName, songName: songName)
                                self.topSongList.append(topSong)
                            }
                        } catch { print("error in url fetching", error.localizedDescription)
                            let topSong = TopSongModel(headShot: self.backUpImage, singer: artistName, songName: songName)
                                self.topSongList.append(topSong)
                        }
                    }
                }
                handler(nil)
            } catch { print("error in parsing", error.localizedDescription)
                handler(error)
            }
        }
    }
    
    func parsePopularSongs(aSimpleHandler handler: @escaping (Error?) -> Void) {
        let paraDictionary = [
            "country": AppConstants.LastFMAPI.topTrackCountry,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "method": AppConstants.LastFMAPIMethod.getTopTracks,
            "format": AppConstants.LastFMAPI.format
        ]
        Service.shared.fetchData(url: baseUrlString, parameters: paraDictionary) { data, error in
            guard let data = data else { return }
            do { let json = try JSONDecoder().decode(Tracks.self, from: data)
                guard let popularSongList = json.tracks?.track else { return }
                for song in popularSongList {
                    if let songName = song.name,
                        let artistName = song.artist?["name"], let headShotString = song.image?.first?["#text"],
                        let durationTime = song.duration, durationTime != "0" {
                        guard let durationInt = Int(durationTime) else { return }
                        var durationSecond = "\(durationInt % 60)"
                        if durationSecond.count == 1 { durationSecond = "0\(durationInt % 60)" }
                        do { guard let url = URL(string: headShotString) else { return }
                            let headShotData = try Data(contentsOf: url)
                            if let headShotImage = UIImage(data: headShotData) {
                                let popuparSong = PopularSongModel(headShot: headShotImage,
                                                                   singer: artistName,
                                                                   songName: songName,
                                                                   duration: "\(durationInt / 60):\(durationSecond)")
                                self.popularSongList.append(popuparSong)
                            }
                        } catch { let popuparSong = PopularSongModel(headShot: self.backUpImage,
                                                                     singer: artistName,
                                                                     songName: songName,
                                                                     duration: "\(durationInt / 60):\(durationSecond)")
                            self.popularSongList.append(popuparSong)
                        }
                    }
                }; handler(nil)
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
        Service.shared.fetchData(url: baseUrlString, parameters: paraDictionary) { data, error in
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
