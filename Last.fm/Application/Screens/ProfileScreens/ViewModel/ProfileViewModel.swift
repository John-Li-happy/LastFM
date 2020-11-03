//
//  ProfileViewModel.swift
//  Last.fm
//
//  Created by Shawn on 9/2/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    var userDataSource = User()
    var recentTracksDataSource = [RecentTrack]()
    var topArtistsDataSource = [UserTopArtist]()
    var topTracksDataSource = [ProfileTopTrack]()
    
    var userInfoParams: [String: String] {
        [
            "method": AppConstants.LastFMAPIMethod.getUserInfo,
            "user": UserDefaults.standard.string(forKey: AppConstants.LoginKey.usernameKey) ?? "",
            "api_key": AppConstants.LastFMAPI.apiKey,
            "format": AppConstants.LastFMAPI.format
        ]
    }
    
    var recentTracksParams: [String: String] {
        [
            "method": AppConstants.LastFMAPIMethod.getUserRecentTracks,
            "user": UserDefaults.standard.string(forKey: AppConstants.LoginKey.usernameKey) ?? "",
            "api_key": AppConstants.LastFMAPI.apiKey,
            "format": AppConstants.LastFMAPI.format
        ]
    }
    
    var topArtistsParams: [String: String] {
        [
            "method": AppConstants.LastFMAPIMethod.getUserTopArtists,
            "user": UserDefaults.standard.string(forKey: AppConstants.LoginKey.usernameKey) ?? "",
            "api_key": AppConstants.LastFMAPI.apiKey,
            "format": AppConstants.LastFMAPI.format
        ]
    }
    
    var topTracksParams: [String: String] {
        [
            "method": AppConstants.LastFMAPIMethod.getUserTopTracks,
            "user": UserDefaults.standard.string(forKey: AppConstants.LoginKey.usernameKey) ?? "",
            "api_key": AppConstants.LastFMAPI.apiKey,
            "format": AppConstants.LastFMAPI.format
        ]
    }
    
    func fetchAPIData(apiParams: [String: String], completeHandler: @escaping (Error?) -> Void) {
        
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: apiParams) { [weak self] data, error in
            
            guard let weakSelf = self, let data = data else {
                completeHandler(error)
                return
            }
            
            do {
                if apiParams == weakSelf.userInfoParams {
                    let json = try JSONDecoder().decode(UserInfo.self, from: data)
                    weakSelf.userDataSource = json.user
                } else if apiParams == weakSelf.recentTracksParams {
                    let json = try JSONDecoder().decode(UserRecentTracks.self, from: data)
                    weakSelf.recentTracksDataSource = json.recentTracks.track
                } else if apiParams == weakSelf.topArtistsParams {
                    let json = try JSONDecoder().decode(UserTopArtists.self, from: data)
                    weakSelf.topArtistsDataSource = json.topArtists.artist
                } else if apiParams == weakSelf.topTracksParams {
                    let json = try JSONDecoder().decode(UserTopTracks.self, from: data)
                    weakSelf.topTracksDataSource = json.topTracks.track
                }
                DispatchQueue.main.async {
                    completeHandler(nil)
                }
            } catch {
                print(error.localizedDescription)
                completeHandler(error)
            }
        }
    }
}
