//
//  LightNavigationController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/18/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class LightNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let mode = UIStatusBarStyle.lightContent
        return mode
    }
}
