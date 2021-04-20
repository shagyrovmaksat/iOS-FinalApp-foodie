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

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationButton.layer.cornerRadius = 5
    }
    

    @IBAction func goToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        let name = nameField.text
        let surname = surnameField.text
        let email = emailField.text
        let password = passwordField.text
        if email != "" && password != "" {
            Auth.auth().createUser(withEmail: email!, password: password!) { [weak self] (result, error) in
//                print(email)
                self?.sendMessageToEmail()
//                print("hi2")
                if error == nil{
//                    print("hi1")
                    if name != "" && surname != ""{
//                        print("hi")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.yyyy"
                        let userData = [
                            "email": email!,
                            "surname": surname!,
                            "name": name!
                        ]
                        Database.database().reference().child("users").child(result!.user.uid).setValue(userData)
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
}
