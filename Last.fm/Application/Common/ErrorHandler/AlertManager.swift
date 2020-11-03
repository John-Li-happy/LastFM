//
//  AlertManager.swift
//  Last.fm
//
//  Created by Shawn Li on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

enum AlertManager {
    enum AlertType: String {
        case invalidInfo = "Invalid User Name or Password"
        case serviceError = ""
        case invalidImage = "Invalid Imaged found"
        case logoutConfirmation = "Are you sure you want to log out?"
    }
    
    static func alert(forWhichPage viewController: UIViewController, alertType: AlertType, alertMessage: String? = nil, handler: ((UIAlertAction) -> Void)?) {
        var message = String()
        // Once add more tittle, let should be changed to var
        var title = "Warning!"
        
        switch alertType {
        case .invalidInfo:
            message = AlertType.invalidInfo.rawValue
            
        case .serviceError:
            guard let alertMessage = alertMessage else { return }
            title = "Error"
            message = alertMessage
            
        case .invalidImage:
            title = "Error"
            message = AlertType.invalidImage.rawValue
            
        case .logoutConfirmation:
            guard let userName = UserDefaults.standard.string(forKey: AppConstants.LoginKey.usernameKey) else { return }
            title = userName
            message = AlertType.logoutConfirmation.rawValue
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Once add more action, let should be changed to var
        if alertType == .logoutConfirmation {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let logoutAction = UIAlertAction(title: "Log out", style: .destructive, handler: handler)
            alertController.addAction(cancelAction)
            alertController.addAction(logoutAction)
        } else {
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
            alertController.addAction(alertAction)
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
