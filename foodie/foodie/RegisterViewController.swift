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
        
    }
}
