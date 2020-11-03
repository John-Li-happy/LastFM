//
//  SearchSimiliarSongsTableViewCell.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 8/25/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class SearchSimiliarSongsTableViewCell: UITableViewCell, ReusableCellProtocol {
    @IBOutlet private var songNameLabel: UILabel!
    
    func configureCell(songName: String) {
        songNameLabel.text = songName
    }
}
