//
//  Artist.swift
//  Last.fm
//
//  Created by Tong Yi on 8/14/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

struct Artists: Decodable {
    var artist: [Artist]
}

struct Image: Decodable {
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size = "size"
    }
    
    var text: URL?
    var size: String
}

struct TopArtist: Decodable {
    enum CodingKeys: String, CodingKey {
        case topArtists = "topartists"
    }
    
    var topArtists: Artists
}

struct Artist: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "name", reference = "mbid"
    }
    
    var name: String
    var reference: String
    var url: URL?
    var image: [Image]?
}
