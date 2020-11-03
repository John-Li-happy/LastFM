//
//  UserTopArtists.swift
//  Last.fm
//
//  Created by Shawn on 9/10/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

struct UserTopArtist: Decodable {
    enum CodingKeys: String, CodingKey {
        case image = "image"
        case name = "name"
        case playCount = "playcount"
    }
    
    var image: [ProfileImage]?
    var name: String?
    var playCount: String?
}

struct TopArtists: Decodable {
    var artist: [UserTopArtist]
}

struct UserTopArtists: Decodable {
    enum CodingKeys: String, CodingKey {
        case topArtists = "topartists"
    }
    
    var topArtists: TopArtists
}
