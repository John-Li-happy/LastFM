//
//  MusicModel.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/21/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class NCSongInfo {
    var songName: String
    var singername: String
    var headShotImage: UIImage
    
    init(songName: String, singerName: String, headShotImage: UIImage) {
        self.songName = songName
        self.singername = singerName
        self.headShotImage = headShotImage
    }
}

@objc class ImportedPlayingSong: NSObject {
    var songName: String
    var singername: String
    
    @objc init(songName: String, singerName: String) {
        self.songName = songName
        self.singername = singerName
    }
}

class ValidSongInfo {
    var urlString: String
    var headShot: UIImage
    
    init(urlString: String, headShot: UIImage) {
        self.urlString = urlString
        self.headShot = headShot
    }
}

struct ArtistInformation: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case pictureString = "picture_big"
    }
    
    var name: String?
    var pictureString: String?
}

struct DataInfo: Decodable {
    var preview: String?
    var artist: ArtistInformation?
}

struct MusicModel: Decodable {
    var data: [DataInfo]?
}
