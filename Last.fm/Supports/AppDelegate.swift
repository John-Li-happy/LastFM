//
//  AppDelegate.swift
//  Last.fm
//
//  Created by Amol Prakash on 10/08/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var showAnimatedView = true
    static var isLoginRootVC = true
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        var rootViewController = UIViewController()
        
        if UserDefaults.standard.bool(forKey: AppConstants.LoginKey.loginStatusKey) {
            rootViewController = storyboard.instantiateViewController(withIdentifier: AppConstants.StoryboardID.mainTabBarController)
            AppDelegate.isLoginRootVC = false
        } else {
            rootViewController = storyboard.instantiateViewController(withIdentifier: AppConstants.StoryboardID.loginViewController)
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        //Shows the window and makes it the key window
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
