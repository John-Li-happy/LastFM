//
//  AlbumBackWardDelegate.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 10/16/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

protocol AlbumBackWardDelegate: AnyObject {
    func albumParentEventHandler(selectedItem: Int)
}
