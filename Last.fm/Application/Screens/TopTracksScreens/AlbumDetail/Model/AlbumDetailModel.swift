//
//  AlbumDetailModel.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/15/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class ValidAlbumTrackDetailInfo {
    var trackName: String
    var trackDuration: String
    var trackSingerName: String
    
    init(trackName: String, trackDuration: String, singer: String) {
        self.trackName = trackName
        self.trackDuration = trackDuration
        self.trackSingerName = singer
    }
}

class ValidAlbumDetailInfo {
    var songCount: String
    var totalTimeDuration: String
    var headShot: UIImage
    var url: String
    
    init(songCount: String, totalAlbumTimeDuration: String, headShot: UIImage, url: String) {
        self.songCount = songCount
        self.totalTimeDuration = totalAlbumTimeDuration
        self.headShot = headShot
        self.url = url
    }
}

struct TrackInfo: Decodable {
    var name: String?
    var duration: String?
    var artist: [String: String]?
}

struct TrackHolder: Decodable {
    var track: [TrackInfo]?
}

struct AlbumInfo: Decodable {
    var image: [[String: String]]?
    var tracks: TrackHolder?
    var url: String?
}

struct AlbumDetailModel: Decodable {
    var album: AlbumInfo?
}
