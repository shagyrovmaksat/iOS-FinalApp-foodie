//
//  EditProfileVC.swift
//  foodie
//
//  Created by Эльвина on 29.04.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProfileVC: UIViewController {

    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var newSurname: UITextField!
    
    var ref: DatabaseReference!
    var currentUser: User?
    var name: String?
    var surname: String?
    var delegate: Editable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newName.text = name
        newSurname.text = surname
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        name = newName.text
        surname = newSurname.text
        delegate?.edit(name: newName.text!, surname: newSurname.text!)
        self.dismiss(animated: true, completion: nil)
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
