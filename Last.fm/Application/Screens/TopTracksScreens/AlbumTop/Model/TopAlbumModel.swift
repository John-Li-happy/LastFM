//
//  TopAlbumModel.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/8/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

//For newTrendingAlbums
class ValidUSerAlbumInfo {
    var artist: String
    var image: UIImage
    var name: String
    
    init(artist: String, image: UIImage, name: String) {
        self.artist = artist
        self.name = name
        self.image = image
    }
}

struct UserAlbumInfo: Decodable {
    var artist: [String: String]?
    var image: [[String: String]]?
    var name: String?
}

struct UserSingleTopAlbum: Decodable {
    var album: [UserAlbumInfo]?
}

struct UserTopAlbums: Decodable {
    var topalbums: UserSingleTopAlbum?
//    var wrong: String // wrong info for testing
}

//For topPopularAlbums
class ValidAlbumInfo {
    var name: String
    var artist: String
    var image: UIImage
    
    init(name: String, artist: String, image: UIImage) {
        self.name = name
        self.artist = artist
        self.image = image
    }
}

struct AlbumsInfo: Decodable {
    var name: String?
    var artist: [String: String]?
    var image: [[String: String]]?
}

struct TopPopularAlbum: Decodable {
    var album: [AlbumsInfo]?
}

struct TopAlbumModel: Decodable {
    var albums: TopPopularAlbum?
//    var wrong: String // wrong info for testing
}
