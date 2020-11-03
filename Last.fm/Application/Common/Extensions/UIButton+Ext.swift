//
//  UIButton+Ext.swift
//  Last.fm
//
//  Created by Tong Yi on 9/2/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

extension UIButton {
    func roundedBorderButton() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
    }
}
