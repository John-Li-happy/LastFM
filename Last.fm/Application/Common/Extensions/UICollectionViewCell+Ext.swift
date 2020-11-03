//
//  UICollectionViewCell+Ext.swift
//  Last.fm
//
//  Created by Tong Yi on 8/25/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func cellWithRoundCorner() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
