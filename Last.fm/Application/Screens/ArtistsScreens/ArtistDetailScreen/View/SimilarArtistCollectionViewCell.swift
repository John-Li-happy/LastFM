//
//  SimilarArtistCollectionViewCell.swift
//  Last.fm
//
//  Created by Tong Yi on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class SimilarArtistCollectionViewCell: UICollectionViewCell, ReusableCellProtocol {
    @IBOutlet weak private var similarArtistImageView: UIImageView! {
        didSet {
            similarArtistImageView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak private var artistNameLabel: UILabel!
    
    func configureItem(name: String, image: UIImage) {
        artistNameLabel.text = name
        similarArtistImageView.image = image
    }
}
