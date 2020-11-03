//
//  BackWardsProtocol.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 10/12/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

protocol BackWardForViewPassMessage: AnyObject {
    func playButtonparentTapped()
    func shareButtonParentTapped()
}

protocol BackWardsForCellPass: AnyObject {
    func playButtonParentTapped(selectedRow: Int)
    func moreButtonParentTapped(selectedRow: Int, songName: String, singerName: String)
}
