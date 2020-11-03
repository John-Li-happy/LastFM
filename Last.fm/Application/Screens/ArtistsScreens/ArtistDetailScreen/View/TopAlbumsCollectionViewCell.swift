//
//  TopAlbumsCollectionViewCell.swift
//  Last.fm
//
//  Created by Tong Yi on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class TopAlbumsCollectionViewCell: UICollectionViewCell, ReusableCellProtocol {
    @IBOutlet weak private var albumImageView: UIImageView! {
        didSet {
            albumImageView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak private var albumNameLabel: UILabel!
    @IBOutlet weak private var albumListenerLabel: UILabel!
    
    func configureCell(name: String, listeners: String, image: UIImage) {
        albumImageView.image = image
        albumNameLabel.text = name
        albumListenerLabel.text = listeners
    }
}
