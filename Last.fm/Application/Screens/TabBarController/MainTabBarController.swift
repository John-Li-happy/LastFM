//
//  TabBarController.swift
//  Last.fm
//
//  Created by Tong Yi on 9/4/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

@objc class MainTabBarController: UITabBarController {
    var rotationFlag = true
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let returnStatus = rotationFlag ? UIInterfaceOrientationMask.all : UIInterfaceOrientationMask.portrait
        return returnStatus
    }
    
    override var shouldAutorotate: Bool {
        let returnBool = rotationFlag ? true : false
        return returnBool
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setObserver()
    }
    
    @objc func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(judgeRotate(notification:)), name: NSNotification.Name("ChannalNCRotate"), object: nil)
    }
    
    @objc func judgeRotate(notification: NSNotification) {
        guard let judged = notification.userInfo?["id"] as? Bool else { return }
        
        if judged {
            rotationFlag = true
        } else {
            rotationFlag = false
        }

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ChannalNCRotate"), object: nil)
    }
}
