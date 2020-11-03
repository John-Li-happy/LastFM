//
//  ProfileNavigationController.swift
//  Last.fm
//
//  Created by Shawn on 9/28/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let lightContent = UIStatusBarStyle.lightContent
        return lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
