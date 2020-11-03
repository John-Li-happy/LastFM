//  Model.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 8/14/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

//for searched resulsts
struct SearchedResults: Decodable {
    var results: TrackMatches?
}

struct TrackMatches: Decodable {
    enum CodingKeys: String, CodingKey {
        case trackMatches = "trackmatches"
    }
    
    var trackMatches: SearchTrack?
}

struct SearchTrack: Decodable {
    var track: [SearchedInfo]?
}

struct SearchedInfo: Decodable {
    var name: String?
}

//for Popular Songs
struct Tracks: Decodable {
    var tracks: Track?
//    var wrong: String // for test wrong api of topSongsCollectionView
}

struct Track: Decodable {
    var track: [PopularSongInfo]?
}

struct PopularSongInfo: Decodable {
    var name: String?
    var artist: [String: String]?
    var image: [[String: String]]?
    var duration: String?
}

class PopularSongModel {
    var headShot: UIImage?
    var singer: String?
    var songName: String?
    var duration: String?
    
    init(headShot: UIImage, singer: String, songName: String, duration: String) {
        self.headShot = headShot
        self.singer = singer
        self.songName = songName
        self.duration = duration
    }
}
//for top Songs
struct TopSongInfo: Decodable {
    var artist: [String: String]?
    var image: [[String: String]]?
    var name: String?
    var url: String?
}

struct ExplanationTopTracks: Decodable {
    var track: [TopSongInfo]?
}

struct MainTopSongModel: Decodable { 
    var similartracks: ExplanationTopTracks?
//    var wrong: String // for test wrong api of topSongsCollectionView
}

class TopSongModel {
    var headShot: UIImage?
    var singer: String?
    var songName: String?
    
    init(headShot: UIImage, singer: String, songName: String) {
        self.headShot = headShot
        self.singer = singer
        self.songName = songName
    }
}
