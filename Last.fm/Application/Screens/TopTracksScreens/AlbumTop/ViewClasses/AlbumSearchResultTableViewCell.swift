//
//  AlbumSearchResultTableViewCell.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/11/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class AlbumSearchResultTableViewCell: UITableViewCell, ReusableCellProtocol {
    @IBOutlet weak private var trackNameLabel: UILabel!
    
    func configureCell(name: String) {
        trackNameLabel.text = name
    }
}
