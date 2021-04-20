//
//  LogInViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 20.04.2021.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logInButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInPressed(_ sender: Any) {
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
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
