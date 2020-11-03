//
//  UserTopArtistsCollectionViewCell.swift
//  Last.fm
//
//  Created by Shawn on 9/10/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class UserTopArtistsCollectionViewCell: UICollectionViewCell, ReusableCellProtocol {
    @IBOutlet weak private var artistAvatarImageView: UIImageView! {
        didSet {
            artistAvatarImageView.roundedImageView(radius: 10)
        }
    }
    @IBOutlet weak private var artistNameLabel: UILabel!
    @IBOutlet weak private var playCountLabel: UILabel!
    
    func configureCell(artistAvatar: String, artistName: String, playCount: String) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: artistAvatar) else { return }
            do {
                let avatarData = try Data(contentsOf: url)
                let avatar = UIImage(data: avatarData)
                DispatchQueue.main.async {
                    self.artistAvatarImageView.image = avatar
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        self.artistNameLabel.text = artistName
        self.playCountLabel.text = playCount + " plays"
    }
}
