//
//  TopArtistViewModel.swift
//  Last.fm
//
//  Created by Tong Yi on 9/1/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

class TopArtistViewModel {
    var dataSource = [Artist]()
    var filteredArtists = [Artist]()
    
    func fetchTopArtistData(completeHandler: @escaping (Error?) -> Void) {
        let parameters = [
            "method": AppConstants.LastFMAPIMethod.getGEOTopArtists,
            "country": AppConstants.LastFMAPI.country,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "limit": AppConstants.LastFMAPI.limitThirty,
            "format": AppConstants.LastFMAPI.format
        ]
        
        Service.shared.fetchData(url: AppConstants.LastFMAPI.apiRootUrl, parameters: parameters) { [weak self] data, error in
            
            guard let weakSelf = self, let data = data else {
                completeHandler(error)
                return
            }
            
            do {
                let json = try JSONDecoder().decode(TopArtist.self, from: data)
                weakSelf.dataSource = json.topArtists.artist
                
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
