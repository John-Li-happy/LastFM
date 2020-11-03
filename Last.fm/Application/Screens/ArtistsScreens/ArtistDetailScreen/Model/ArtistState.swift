//
//  ArtistStatus.swift
//  Last.fm
//
//  Created by Tong Yi on 9/1/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

enum ShowAllFlags {
    static var artistAlbumToAllFlag = true // initial true
    static var artistTrackToAllFlag = true // initial true
    static var artistSimilarToAllFlag = true // initial true
}

enum ReloadFlags {
    static var artistAlbumReloadFlag = 0 // initial 0
    static var artistTrackReloadFlag = 0 // initial 0
    static var artistSimilarReloadFlag = 0 // initial 0
}

// For topTracks
class ValidArtistTopTrack {
    var name: String
    var playCount: String
    
    init(name: String, playCount: String) {
        self.name = name
        self.playCount = playCount
    }
}

struct ArtistTopTrack: Decodable {
    var name: String?
    var playcount: String?
}

struct TrackList: Decodable {
    var track: [ArtistTopTrack]?
}

struct TopTrackContainer: Decodable {
    enum CodingKeys: String, CodingKey {
        case topTracks = "toptracks"
    }
    
    var topTracks: TrackList?
}

// For topAlbums
class ValidArtistAlbum {
    var name: String
    var playCount: String
    var headShotImage: UIImage
    
    init(name: String, playCount: String, headShotImage: UIImage) {
        self.name = name
        self.playCount = playCount
        self.headShotImage = headShotImage
    }
}

struct ArtistAlbumInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case playCount = "playcount"
        case image = "image"
    }
    
    var name: String?
    var playCount: Int?
    var image: [[String: String]]?
}

struct TopAlbumsContainer: Decodable {
    var album: [ArtistAlbumInfo]?
}

struct TopAlbumsFolder: Decodable {
    enum CodingKeys: String, CodingKey {
        case topAlbums = "topalbums"
    }
    
    var topAlbums: TopAlbumsContainer?
}

// For artistDetail + simmiliar artists
struct ArtistInfo: Decodable {
    var artist: ArtistState
}

class SimiliarArtist {
    var artistName: String
    var headShotImage: UIImage
    
    init(artistName: String, headShotImage: UIImage) {
        self.artistName = artistName
        self.headShotImage = headShotImage
    }
}

class ArtistDetail {
    var listeners: String
    var scrolbbles: String
    var headShot: UIImage
    var url: URL
    
    init(listeners: String, scrolbbles: String, headShot: UIImage, url: URL) {
        self.listeners = listeners
        self.scrolbbles = scrolbbles
        self.headShot = headShot
        self.url = url
    }
}

struct ArtistStatus: Decodable {
    enum CodingKeys: String, CodingKey {
        case listeners = "listeners"
        case playCount = "playcount"
    }
    
    var listeners: String
    var playCount: String
}

enum RowNumsForArtistDetailPage: Int {
    case topArtAlbumsOrSimilarArts = 1
    case topArtistTracks = 10
}

struct SimiliarContainer: Decodable {
    var artist: [SimiliarArtistInfo]?
}

struct SimiliarArtistInfo: Decodable {
    var name: String?
    var image: [[String: String]]?
}

struct ArtistState: Decodable {
    enum CodingKeys: String, CodingKey {
        case status = "stats"
        case image = "image"
        case similar = "similar"
        case url = "url"
    }
    
    var status: ArtistStatus
    var image: [[String: String]]?
    var similar: SimiliarContainer?
    var url: String?
}
