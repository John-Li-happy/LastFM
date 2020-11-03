//
//  newTrendingAlbumCell.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/8/20.
//  Copyright © 2020  Prakash. All rights reserved.
//

import Foundation
import UIKit

class NewTrendingAlbumCollectionViewCell: UICollectionViewCell, ReusableCellProtocol {
    var headShotNarrowWidthConstraint = NSLayoutConstraint()
    var headShotWideWidthConstraint = NSLayoutConstraint()
    
    @IBOutlet weak private var newTrendingAlbumNameLabel: UILabel!
    @IBOutlet weak private var newTrendingArtistNameLabel: UILabel!
    @IBOutlet weak private var newTrendingHeadShotImageView: UIImageView! {
        didSet {
            newTrendingHeadShotImageView.roundedImageView(radius: 20)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headShotWideWidthConstraint = NSLayoutConstraint(item: newTrendingHeadShotImageView ?? UIView(),
                                                         attribute: .width,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .width,
                                                         multiplier: 1,
                                                         constant: 250)
        headShotNarrowWidthConstraint = NSLayoutConstraint(item: newTrendingHeadShotImageView ?? UIView(),
                                                           attribute: .width,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .width,
                                                           multiplier: 1,
                                                           constant: 185)
    }
    
    func configureNewTrendingCell(albumName: String, artistName: String, headShotImage: UIImage, imageStatus: Bool) {
        newTrendingAlbumNameLabel.text = albumName
        newTrendingArtistNameLabel.text = artistName
        newTrendingHeadShotImageView.image = headShotImage
        if imageStatus {
            for constraint in contentView.constraints where constraint == headShotNarrowWidthConstraint {
                contentView.removeConstraint(headShotNarrowWidthConstraint)
            }
        } else {
            contentView.removeConstraint(headShotWideWidthConstraint)
            contentView.addConstraint(headShotNarrowWidthConstraint)
        }
    }
}
