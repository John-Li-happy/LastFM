//
//  UIImageView+Ext.swift
//  Last.fm
//
//  Created by Shawn Li on 8/28/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func roundedImageView(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func borderedImageView(color: CGColor, width: CGFloat) {
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
}
