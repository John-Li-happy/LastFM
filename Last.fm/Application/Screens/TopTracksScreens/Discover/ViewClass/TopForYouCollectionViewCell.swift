//
//  TopForYouCollectionViewCell.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 8/17/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class TopForYouCollectionViewCell: UICollectionViewCell, ReusableCellProtocol {
    @IBOutlet weak private var headShotImageView: UIImageView! {
        didSet {
            headShotImageView.roundedImageView(radius: 10)
        }
    }
    @IBOutlet weak private var songNameLabel: UILabel! {
        didSet {
            songNameLabel.textColor = .white
        }
    }
    @IBOutlet weak private var artistNameLabel: UILabel! {
        didSet {
            artistNameLabel.textColor = .white
        }
    }
    
    func configureCell(inputImage: UIImage, inputSongName: String, inputArtistName: String) {
        headShotImageView.image = inputImage
        songNameLabel.text = inputSongName
        artistNameLabel.text = inputArtistName
    }
}
