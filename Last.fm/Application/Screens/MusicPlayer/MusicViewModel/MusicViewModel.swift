//
//  MusicViewModel.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/21/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class MusicViewModel {
    let rootURL = "https://api.deezer.com/search"
    var validSongInfo = ValidSongInfo(urlString: String(), headShot: UIImage())
        
    func audioInfohandle(songName: String, singerName: String, asimpleHandler handler: @escaping (Bool, Error?) -> Void) {
        let paraDictionary = ["q": songName]
        validSongInfo = ValidSongInfo(urlString: String(), headShot: UIImage())
        var songInfoNotNil = false
        var components = URLComponents(string: rootURL)
        components?.queryItems = paraDictionary.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        Service.shared.fetchData(url: rootURL, parameters: paraDictionary) { data, error in
            if let data = data, error == nil {
                do {
                    let json = try JSONDecoder().decode(MusicModel.self, from: data)
                    guard let possibleTracks = json.data else { return }
                    for possibleTrack in possibleTracks where singerName == possibleTrack.artist?.name {
                        guard let url = URL(string: possibleTrack.artist?.pictureString ?? "") else { continue }
                        let imageData = try Data(contentsOf: url)
                        guard let validString = possibleTrack.preview, let headShotImage = UIImage(data: imageData) else { continue }
                        self.validSongInfo = ValidSongInfo(urlString: validString, headShot: headShotImage)
                        songInfoNotNil = true
                        handler(songInfoNotNil, nil)
                        return
                    }
                    if !songInfoNotNil {
                        handler(songInfoNotNil, nil)
                    }
                } catch {
                handler(songInfoNotNil, error) }
            }
        }
    }
}
