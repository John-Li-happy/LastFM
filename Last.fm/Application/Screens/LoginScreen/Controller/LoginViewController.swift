//
//  LoginViewController.swift
//  Last.fm
//
//  Created by Shawn Li on 8/14/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import SafariServices
import SVProgressHUD
import SwiftyGif
import UIKit

class LoginViewController: UIViewController, SwiftyGifDelegate {
    
    let logoAnimationView = LogoAnimationView()
    private var isCheckBoxSelected = false
    private var showPasswordButton = UIButton()
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet {
            showPasswordButton = UIButton(type: .custom)
            passwordTextField.rightViewMode = .unlessEditing
            if #available(iOS 13.0, *) {
                showPasswordButton.setImage(UIImage(systemName: AppConstants.ImageName.eyeClosedSystemImageViewName), for: .normal)
            } else {
                // Fallback on earlier versions
                showPasswordButton.setImage(UIImage(named: AppConstants.ImageName.eyeClosedImageViewName), for: .normal)
            }
            showPasswordButton.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(35), height: CGFloat(35))
            showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped(_:)), for: .touchUpInside)
            passwordTextField.rightView = showPasswordButton
            passwordTextField.rightViewMode = .always
        }
    }
    @IBOutlet private weak var checkBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserStatus()
        setupUI()
        setupCheckbox()
        if AppDelegate.isLoginRootVC && AppDelegate.showAnimatedView {
            view.addSubview(logoAnimationView)
            logoAnimationView.pinEdgesToSuperView()
            logoAnimationView.logoGifImageView.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.isLoginRootVC && AppDelegate.showAnimatedView {
            logoAnimationView.logoGifImageView.startAnimatingGif()
        }
    }
    
    @IBAction private func checkBoxBtnTapped(_ sender: UIButton) {
        isCheckBoxSelected.toggle()
        setupCheckbox()
    }
    
    @IBAction private func forgetPWBtnTapped(_ sender: UIButton) {
        directToWebSite(url: AppConstants.LastFMAPI.forgetPasswordUrl)
    }
    
    @IBAction private func signinBtnTapped(_ sender: UIButton) {
        SVProgressHUD.show()
        userSignin()
    }
    
    @IBAction private func signUpBtnTapped(_ sender: UIButton) {
        directToWebSite(url: AppConstants.LastFMAPI.registerUrl)
    }
    
    @objc private func showPasswordButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            passwordTextField.isSecureTextEntry = false
            if #available(iOS 13.0, *) {
                showPasswordButton.setImage(UIImage(systemName: AppConstants.ImageName.eyeOpenSystemImageViewName), for: .normal)
            } else {
                // Fallback on earlier versions
                showPasswordButton.setImage(UIImage(named: AppConstants.ImageName.eyeOpenImageViewName), for: .normal)
            }
        } else {
            passwordTextField.isSecureTextEntry = true
            if #available(iOS 13.0, *) {
                showPasswordButton.setImage(UIImage(systemName: AppConstants.ImageName.eyeClosedSystemImageViewName), for: .normal)
            } else {
                // Fallback on earlier versions
                showPasswordButton.setImage(UIImage(named: AppConstants.ImageName.eyeClosedImageViewName), for: .normal)
            }
        }
    }
    
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
    
    func checkUserStatus() {
        if UserDefaults.standard.bool(forKey: AppConstants.LoginKey.rememberStatusKey) {
            usernameTextField.text = UserDefaults.standard.string(forKey: AppConstants.LoginKey.usernameKey)
            isCheckBoxSelected = UserDefaults.standard.bool(forKey: AppConstants.LoginKey.rememberStatusKey)
        }
    }
    
    func setupUI() {
        logoImageView.roundedImageView(radius: logoImageView.frame.size.width / 2)
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        SVProgressHUD.setContainerView(self.view)
    }
    
    func setupCheckbox() {
        if isCheckBoxSelected {
            if #available(iOS 13.0, *) {
                checkBox.setImage(UIImage(systemName: AppConstants.ImageName.checkedSystemImageViewName), for: .normal)
            } else {
                // Fallback on earlier versions
                checkBox.setImage(UIImage(named: AppConstants.ImageName.checkedImageViewName), for: .normal)
            }
        } else {
            if #available(iOS 13.0, *) {
                checkBox.setImage(UIImage(systemName: AppConstants.ImageName.uncheckedSystemImageViewName), for: .normal)
            } else {
                // Fallback on earlier versions
                checkBox.setImage(UIImage(named: AppConstants.ImageName.uncheckedImageViewName), for: .normal)
            }
        }
    }
    
    func userSignin() {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            Service.shared.postUserAuthentication(userName: username, password: password) { sessionKey, status in
                if status {
                    UserDefaults.standard.set(sessionKey, forKey: AppConstants.LoginKey.sessionKey)
                    self.navigateToHome()
                } else {
                    AlertManager.alert(forWhichPage: self, alertType: .invalidInfo) { _ in
                        self.passwordTextField.text = nil
                        SVProgressHUD.dismiss()
                    }
                }
                UserDefaults.standard.set(status, forKey: AppConstants.LoginKey.loginStatusKey)
                UserDefaults.standard.set(username, forKey: AppConstants.LoginKey.usernameKey)
                UserDefaults.standard.set(self.isCheckBoxSelected, forKey: AppConstants.LoginKey.rememberStatusKey)
            }
        }
    }
        
    func directToWebSite(url: String) {
        guard let url = URL(string: url) else { return }
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true)
    }
    
    // MARK: - Temp: Derict to Next Page
    func navigateToHome() {
       let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
       let tabBarController = storyboard.instantiateViewController(withIdentifier: AppConstants.StoryboardID.mainTabBarController)
       let window = UIApplication.shared.windows.first
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
