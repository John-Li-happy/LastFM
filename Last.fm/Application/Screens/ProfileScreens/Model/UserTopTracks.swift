//
//  UserTopTracks.swift
//  Last.fm
//
//  Created by Shawn on 9/14/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

struct TopTrackArtist: Decodable {
    var name: String?
}

struct ProfileTopTrack: Decodable {
    var duration: String?
    var artist: TopTrackArtist?
    var image: [ProfileImage]?
    var name: String?
}

struct ProfileTopTracks: Decodable {
    var track: [ProfileTopTrack]
}

struct UserTopTracks: Decodable {
    enum CodingKeys: String, CodingKey {
        case topTracks = "toptracks"
    }
    
    var topTracks: ProfileTopTracks
}
