//
//  TopAlbumViewModel.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/8/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class TopAlbumViewModel {
    var topPopularAlbumDataSource = [ValidAlbumInfo]()
    var newTrendingAlbumsDataSource = [ValidUSerAlbumInfo]()
    var searchedSongList = [SearchedInfo]()
    
    func parseNewTrendingAlbums(aSimpleHandler handler: @escaping (Error?) -> Void) {
        var parseNewError: Error?
        let paraDictionary = [
            "user": UserDefaults.standard.string(forKey: AppConstants.LoginKey.usernameKey) ?? "",
            "api_key": AppConstants.LastFMAPI.apiKey,
            "method": AppConstants.LastFMAPIMethod.getUserTopAlbums,
            "format": AppConstants.LastFMAPI.format
        ]
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: paraDictionary) { data, error in
            guard let data = data else { return }
            if error != nil {}
            do {
                let json = try JSONDecoder().decode(UserTopAlbums.self, from: data)
                guard let albums = json.topalbums?.album else { return }
                for album in albums {
                    if let albumName = album.name,
                        let singerName = album.artist?["name"],
                        let headShotImageString = album.image?[3]["#text"] {
                        if let url = URL(string: headShotImageString) {
                            let headShotData = try Data(contentsOf: url)
                            if let headShotImage = UIImage(data: headShotData) {
                                let singleAlbum = ValidUSerAlbumInfo(artist: singerName, image: headShotImage, name: albumName)
                                self.newTrendingAlbumsDataSource.append(singleAlbum)
                            }
                        } else {
                            let headShotImage = UIImage(imageLiteralResourceName: AppConstants.ImageName.unfetchedImageName)
                            let singleAlbum = ValidUSerAlbumInfo(artist: singerName, image: headShotImage, name: albumName)
                            self.newTrendingAlbumsDataSource.append(singleAlbum)
                        }
                    }
                }
            } catch { parseNewError = error }
            // Edge case handling
            if self.newTrendingAlbumsDataSource.isEmpty {
                self.backUpNewTrendingAlbums {
                    if self.newTrendingAlbumsDataSource.isEmpty {
                        handler(parseNewError)
                    }
                    handler(nil)
                }
            }
            handler(nil)
        }
    }
    
    func backUpNewTrendingAlbums(aSimpleHandler handler: @escaping () -> Void) {
        let paraDictionary = [
            "tag": AppConstants.LastFMAPI.backUpTag,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "method": AppConstants.LastFMAPIMethod.getTagTopAlbums,
            "format": AppConstants.LastFMAPI.format
        ]
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: paraDictionary) { data, error in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(TopAlbumModel.self, from: data)
                guard let albums = json.albums?.album else { return }
                for album in albums {
                    if let albumName = album.name,
                        let singerName = album.artist?["name"],
                        let headShotString = album.image?[3]["#text"] {
                        if let url = URL(string: headShotString) {
                            let imageData = try Data(contentsOf: url)
                            if let headShotImage = UIImage(data: imageData) {
                                let singleAlbum = ValidUSerAlbumInfo(artist: singerName, image: headShotImage, name: albumName)
                                self.newTrendingAlbumsDataSource.append(singleAlbum)
                            } else {
                                let singleAlbum = ValidUSerAlbumInfo(artist: singerName, image: UIImage(imageLiteralResourceName: AppConstants.ImageName.unfetchedImageName), name: albumName)
                                self.newTrendingAlbumsDataSource.append(singleAlbum)
                            }
                        }
                    }
                }
            } catch { print("error in parsing", error.localizedDescription) }
            handler()
        }
    }
    
    func parseTopPopularAlbum(aSimpleHandler handler: @escaping (Error?) -> Void) {
        let paraDictionary = [
            "tag": AppConstants.LastFMAPI.backTag,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "method": AppConstants.LastFMAPIMethod.getTagTopAlbums,
            "format": AppConstants.LastFMAPI.format
        ]
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: paraDictionary) { data, error in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(TopAlbumModel.self, from: data)
                guard let albums = json.albums?.album else { return }
                for album in albums {
                    if let albumName = album.name,
                        let singerName = album.artist?["name"],
                        let headShotString = album.image?[3]["#text"] {
                        guard let url = URL(string: headShotString) else { return }
                        let imageData = try Data(contentsOf: url)
                        if let headShotImage = UIImage(data: imageData) {
                            let singleAlbum = ValidAlbumInfo(name: albumName, artist: singerName, image: headShotImage)
                            self.topPopularAlbumDataSource.append(singleAlbum)
                        } else {
                            let singleAlbum = ValidAlbumInfo(name: albumName, artist: singerName, image: UIImage(imageLiteralResourceName: AppConstants.ImageName.unfetchedImageName))
                            self.topPopularAlbumDataSource.append(singleAlbum)
                        }
                    }
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
