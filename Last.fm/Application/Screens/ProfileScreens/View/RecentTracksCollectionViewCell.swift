//
//  RecentTracksCollectionViewCell.swift
//  Last.fm
//
//  Created by Shawn on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class RecentTracksCollectionViewCell: UICollectionViewCell, ReusableCellProtocol {
    @IBOutlet weak private var trackCoverImageView: UIImageView! {
        didSet {
            trackCoverImageView.roundedImageView(radius: 10)
        }
    }
    @IBOutlet weak private var trackNameLabel: UILabel!
    @IBOutlet weak private var trackArtistLabel: UILabel!
    
    func configureCell(trackCover: String, trackName: String, artist: String) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: trackCover) else { return }
            do {
                let coverData = try Data(contentsOf: url)
                let cover = UIImage(data: coverData)
                DispatchQueue.main.async {
                    self.trackCoverImageView.image = cover
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        self.trackNameLabel.text = trackName
        self.trackArtistLabel.text = artist
    }
}
