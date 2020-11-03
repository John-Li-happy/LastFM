//
//  UserRecentTracks.swift
//  Last.fm
//
//  Created by Shawn on 9/10/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

struct RecentArtist: Decodable {
    enum CodingKeys: String, CodingKey {
        case artistName = "#text"
    }
    
    var artistName: String?
}

struct RecentTrack: Decodable {
    var image: [ProfileImage]?
    var artist: RecentArtist?
    var name: String?
}

struct RecentTracks: Decodable {
    var track: [RecentTrack]
}

struct UserRecentTracks: Decodable {
    enum CodingKeys: String, CodingKey {
        case recentTracks = "recenttracks"
    }
    
    var recentTracks: RecentTracks
}
