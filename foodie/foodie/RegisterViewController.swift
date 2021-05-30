//
//  RegisterViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 20.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import LanguageManager_iOS

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationButton.layer.cornerRadius = 5
        indicator.isHidden = true
    }
    

    @IBAction func goToLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let mainPage = storyboard.instantiateViewController(identifier: "LogInViewController") as? UIViewController {
            self.present(mainPage, animated: true, completion: nil)
        }
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        let name = nameField.text
        let surname = surnameField.text
        let email = emailField.text
        let password = passwordField.text
        if email != "" && password != "" {
            indicator.startAnimating()
            indicator.isHidden = false
            Auth.auth().createUser(withEmail: email!, password: password!) { [weak self] (result, error) in
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
                self?.sendMessageToEmail()
                if error == nil{
                    if name != "" && surname != ""{
                        let userData = [
                            "email": email!,
                            "surname": surname!,
                            "name": name!
                        ]
                        Database.database().reference().child("users").child(result!.user.uid).setValue(userData)
                        let favRecipes: [Recipe] = []
                        Database.database().reference().child("users").child(result!.user.uid).child("favoriteRecipes").setValue(favRecipes)
                        self?.showMessage(title: "Success", message: "Please verify your email")
                    }
                }
                else{
                    self?.showMessage(title: "Error", message: "Some problem occured")
                }
            }
        }
    }
    
    func sendMessageToEmail(){
        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
    }
    
    func showMessage(title: String, message: String){
        //create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            if title != "Error"{
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(okAction)
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
        emailField.placeholder = "Email".addLocalizableString(str: language)
        nameField.placeholder = "Name".addLocalizableString(str: language)
        surnameField.placeholder = "Surname".addLocalizableString(str: language)
        passwordField.placeholder = "Password".addLocalizableString(str: language)
        registrationLabel.text = "Registration".addLocalizableString(str: language)
        createButton.setTitle("Create an account".addLocalizableString(str: language), for: .normal)
        logInButton.setTitle("Already have an account? Log In".addLocalizableString(str: language), for: .normal)
    }
}
