//
//  LogInViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 20.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import RAMAnimatedTabBarController
import LanguageManager_iOS

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    var currentUser : User?
    var isLaunched = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logInButton.layer.cornerRadius = 5
        indicator.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        if currentUser != nil && currentUser!.isEmailVerified {
            goToMain()
        } 
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        indicator.startAnimating()
        indicator.isHidden = false
        if email != "" && password != "" {
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self](result, error) in
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
                if error == nil {
                    if Auth.auth().currentUser!.isEmailVerified {
                        self?.goToMain()
                    } else {
                        self?.showMessage(title: "Warning", message: "Your email is not verified")
                    }
                } else {
                    self?.showMessage(title: "Error", message: "Some problem occured")
                }
            }
        }
    }
    
    func goToMain() {
        let mainPage = TabbarVC()
        mainPage.modalPresentationStyle = .fullScreen
        present(mainPage, animated: true)
    }
    
    
    func showMessage(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeToEng(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .en)
        updateLanguage(LanguageManager.shared.currentLanguage.rawValue)
    }
    
    @IBAction func changeToRus(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .ru)
        updateLanguage(LanguageManager.shared.currentLanguage.rawValue)
    }
    
    @IBAction func changeToKaz(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .ko)
        updateLanguage("ko")
    }
    
    func updateLanguage(_ language: String) {
        createButton.setTitle("Don't have an account? Create one!".addLocalizableString(str: language), for: .normal)
        logInButton.setTitle("Log In".addLocalizableString(str: language), for: .normal)
        label1.text = "Log In".addLocalizableString(str: language)
        emailTextField.placeholder = "Email".addLocalizableString(str: language)
        passwordTextField.placeholder = "Password".addLocalizableString(str: language)
    }
}

extension UIStoryboard {
    static let onboarding = UIStoryboard(name: "Onboarding", bundle: nil)
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
