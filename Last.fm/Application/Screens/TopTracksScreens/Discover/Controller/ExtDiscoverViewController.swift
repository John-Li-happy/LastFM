//
//  ExtDiscoverViewController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 10/14/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class ExtDiscoverViewController {
}

extension DiscoverViewController {
    @objc func disableRotation() {
        guard let tabBarController = self.tabBarController as? MainTabBarController else {
            print("no tab bar found")
            return }
        tabBarController.setObserver()
        let storeIDDic = ["id": false]
        NotificationCenter.default.post(name: NSNotification.Name("ChannalNCRotate"), object: nil, userInfo: storeIDDic)
    }

    @objc func enableRotattion() {
        guard let tabBarController = self.tabBarController as? MainTabBarController else {
            print("no tab bar found")
            return }
        tabBarController.setObserver()
        let storeIDDic = ["id": true]
        NotificationCenter.default.post(name: NSNotification.Name("ChannalNCRotate"), object: nil, userInfo: storeIDDic)
    }
}
