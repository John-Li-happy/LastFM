//
//  ArtistDetailPageViewModel.swift
//  Last.fm
//
//  Created by Tong Yi on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

class ArtistDetailPageViewModel {
    var artistStatus: ArtistStatus?
    var similiarArtistList = [SimiliarArtist]()
    var validArtistAlbumList = [ValidArtistAlbum]()
    var validArtistTopTrackList = [ValidArtistTopTrack]()
    var sections = ["Top Albums", "Top Songs", "Similiar Artists"]
    
    func fetchArtistTopTracks(artistName: String, aSimpleHandler handler: @escaping (Error?) -> Void) {
        self.validArtistTopTrackList = [ValidArtistTopTrack]()
        
        let parameters = [
            "method": "artist.getTopTracks",
            "artist": artistName,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "format": AppConstants.LastFMAPI.format
        ]
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: parameters) { data, error in
            guard let data = data else {
                handler(error)
                return }
            do {
                let json = try JSONDecoder().decode(TopTrackContainer.self, from: data)
                guard let trackList = json.topTracks?.track else { return }
                for track in trackList {
                    if let name = track.name,
                       let playCount = track.playcount {
                        let validTrack = ValidArtistTopTrack(name: name, playCount: accuracyFloat(number: playCount))
                        self.validArtistTopTrackList.append(validTrack)
                    }
                    if self.validArtistTopTrackList.count > 9 {
                        handler(nil)
                        return
                    }
                }
                handler(nil)
            } catch { handler(error) }
        }
    }
    
    func fetchArtistTopAlbum(artistName: String, aSimpleHandler handler: @escaping (Error?) -> Void) {
        validArtistAlbumList = [ValidArtistAlbum]()
        
        let parameters = [
            "method": "artist.getTopAlbums",
            "artist": artistName,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "format": AppConstants.LastFMAPI.format,
            "limit": "10"
        ]
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: parameters) { data, error in
            guard let data = data else {
                handler(error)
                return }
            do {
                let json = try JSONDecoder().decode(TopAlbumsFolder.self, from: data)
                guard let albumList = json.topAlbums?.album else { return }
                for album in albumList {
                    if let name = album.name,
                       let playCountInt = album.playCount {
                        if let imageString = album.image?[3]["#text"] {
                            guard let url = URL(string: imageString) else { return }
                            let imageData = try Data(contentsOf: url)
                            let image = UIImage(data: imageData)
                            let singleAlbum = ValidArtistAlbum(name: name,
                                                               playCount: accuracyFloat(number: String(playCountInt)),
                                                               headShotImage: image ?? UIImage(imageLiteralResourceName: "unfetchedImage"))
                            self.validArtistAlbumList.append(singleAlbum)
                        } else {
                            let singleAlbum = ValidArtistAlbum(name: name, playCount: accuracyFloat(number: String(playCountInt)), headShotImage: UIImage(imageLiteralResourceName: "unfetchedImage"))
                            self.validArtistAlbumList.append(singleAlbum)
                        }
                    }
                }
                print("handled no error")
                handler(nil)
            } catch {
                print("handled error")
                handler(error) }
        }
        print("")
    }
    
    func fetchArtisDetail(artistName: String, completeHandler: @escaping (ArtistDetail?, Error?) -> Void) {
        self.similiarArtistList = [SimiliarArtist]()
        let parameters = [
            "method": AppConstants.LastFMAPIMethod.getArtistInfo,
            "artist": artistName,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "format": AppConstants.LastFMAPI.format
        ]
        
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: parameters) { data, error in            
            guard let data = data else {
                completeHandler(nil, error)
                return
            }
            do {
                let json = try JSONDecoder().decode(ArtistInfo.self, from: data)
                guard let artistList = json.artist.similar?.artist else { return }
                for artist in artistList {
                    if let imageString = artist.image?[3]["#text"],
                       let name = artist.name {
                        guard let url = URL(string: imageString) else { return }
                        let imageData = try Data(contentsOf: url)
                        let headShot = UIImage(data: imageData)
                        let oneSimilarArtist = SimiliarArtist(artistName: name, headShotImage: headShot ?? UIImage(imageLiteralResourceName: "unfetchedImage"))
                        self.similiarArtistList.append(oneSimilarArtist)
                    }
                }
                guard let urlStirng = json.artist.url else { return }
                guard let artistURL = URL(string: urlStirng) else { return }
                if let imageURLString = json.artist.image?[3]["#text"] {
                    guard let url = URL(string: imageURLString) else { return }
                    let imageData = try Data(contentsOf: url)
                    let headShotImage = UIImage(data: imageData)
                    let artistDetail = ArtistDetail(listeners: json.artist.status.listeners,
                                                    scrolbbles: json.artist.status.playCount,
                                                    headShot: headShotImage ?? UIImage(imageLiteralResourceName: "SingerExample"),
                                                    url: artistURL)
                    completeHandler(artistDetail, nil)
                } else {
                    let artistDetail = ArtistDetail(listeners: json.artist.status.listeners,
                                                    scrolbbles: json.artist.status.playCount,
                                                    headShot: UIImage(imageLiteralResourceName: "SingerExample"),
                                                    url: artistURL)
                    completeHandler(artistDetail, nil)
                }
            } catch {
                print(error.localizedDescription)
                completeHandler(nil, error)
            }
        }
    }
}
