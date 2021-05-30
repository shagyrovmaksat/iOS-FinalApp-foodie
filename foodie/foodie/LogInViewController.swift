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
import TransitionButton

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    let button = TransitionButton(frame: CGRect(x: 0, y: 0, width: 250, height: 52))
    var currentUser : User?
    var isLaunched = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.backgroundColor = UIColor(named: "darkGreen")
        button.layer.cornerRadius = 20
        button.setTitle("Log In", for: .normal)
        button.tintColor = UIColor(named: "lightGreen")
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.center.x = view.center.x
        button.center.y = view.center.y + 200
        view.addSubview(button)
        
        button.spinnerColor = UIColor(named: "lightGreen")!
        
        indicator.isHidden = true
    }
    
    @objc func didTapButton(){
        button.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let email = self.emailTextField.text
            let password = self.passwordTextField.text
            if email != "" && password != "" {
                Auth.auth().signIn(withEmail: email!, password: password!) { [weak self](result, error) in
                    self?.button.stopAnimation(animationStyle: .expand, revertAfterDelay: 0.8) {
                        if error == nil {
                            if Auth.auth().currentUser!.isEmailVerified {
                                self?.goToMain()
                            } else {
                                self?.showMessage(title: "Warning", message: "Your email is not verified")
                            }
                        } else {
                            print(error)
                            self?.showMessage(title: "Error", message: "Some problem occured")
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        if currentUser != nil && currentUser!.isEmailVerified {
            goToMain()
        } 
    }
    
    
    func goToMain() {
        let mainPage = TabbarVC()
        mainPage.modalPresentationStyle = .fullScreen
        mainPage.modalTransitionStyle = .crossDissolve
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
        updateLanguage(LanguageManager.shared.currentLanguage.rawValue)
    }
    
    func updateLanguage(_ language: String) {
        createButton.setTitle("Don't have an account? Create one!".addLocalizableString(str: language), for: .normal)
        button.setTitle("Log In".addLocalizableString(str: language), for: .normal)
        label1.text = "Log In".addLocalizableString(str: language)
        emailTextField.placeholder = "Email".addLocalizableString(str: language)
        passwordTextField.placeholder = "Password".addLocalizableString(str: language)
    }
}
