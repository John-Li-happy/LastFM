//
//  SceneDelegate.swift
//  Last.fm
//
//  Created by Amol Prakash on 10/08/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        // Default is Main
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        var rootViewController = UIViewController()
        
        if UserDefaults.standard.bool(forKey: AppConstants.LoginKey.loginStatusKey) {
            rootViewController = storyboard.instantiateViewController(identifier: AppConstants.StoryboardID.mainTabBarController)
        } else {
            rootViewController = storyboard.instantiateViewController(identifier: AppConstants.StoryboardID.loginViewController)
        }
        
        window?.rootViewController = rootViewController
        //Shows the window and makes it the key window
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
