//
//  UserInfo.swift
//  Last.fm
//
//  Created by Shawn on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

struct ProfileImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "#text"
    }
    
    var imageUrl: String?
}

struct User: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case realName = "realname"
        case gender = "gender"
        case age = "age"
        case country = "country"
        case playCount = "playcount"
        case image = "image"
    }
    
    var name: String?
    var realName: String?
    var gender: String?
    var age: String?
    var country: String?
    var playCount: String?
    var image: [ProfileImage]?
}

struct UserInfo: Decodable {
    var user: User
}
