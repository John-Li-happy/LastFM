//
//  SharetoHeaderView.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 10/19/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class SharetoHeaderView: UIView {
    @IBOutlet private weak var headShotImageView: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var singerLabel: UILabel!
    
    func configureView(image: UIImage, song: String, singer: String) {
        headShotImageView.image = image
        songNameLabel.text = song
        singerLabel.text = singer
    }
}
