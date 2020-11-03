//
//  GeoPopularSongsTableViewCell.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 8/18/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class GeoPopularSongsTableViewCell: UITableViewCell, ReusableCellProtocol {
    @IBOutlet weak private var headShotImageView: UIImageView!
    @IBOutlet weak private var songNameLabel: UILabel! {
        didSet {
            songNameLabel.textColor = .white
        }
    }
    @IBOutlet weak private var singerNameLabel: UILabel! {
        didSet {
            singerNameLabel.textColor = .white
        }
    }
    @IBOutlet weak private var durationTimeLabel: UILabel! {
        didSet {
            durationTimeLabel.textColor = .white
        }
    }
    
    func configureCell(songName: String, headShotImage: UIImage, singerName: String, durationTime: String) {
        self.headShotImageView.image = headShotImage
        self.songNameLabel.text = songName
        self.singerNameLabel.text = singerName
        self.durationTimeLabel.text = durationTime
    }
}
