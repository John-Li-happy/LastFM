//
//  TopPopularAlbumsCollectionViewCell.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/8/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class TopPopularAlbumsCollectionViewCell: UICollectionViewCell, ReusableCellProtocol {
    @IBOutlet weak private var topPopularHeadShotImageView: UIImageView! {
        didSet {
            topPopularHeadShotImageView.roundedImageView(radius: 20)
        }
    }
    @IBOutlet weak private var topPopularAlbumNameLabel: UILabel!
    @IBOutlet weak private var topPopularArtistNameLabel: UILabel!
    
    func configureTopPopularCell(albumName: String, artistName: String, headShotImage: UIImage) {
        topPopularAlbumNameLabel.text = albumName
        topPopularArtistNameLabel.text = artistName
        topPopularHeadShotImageView.image = headShotImage
    }
}
