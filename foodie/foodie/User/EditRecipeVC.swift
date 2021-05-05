//
//  EditRecipeVC.swift
//  foodie
//
//  Created by Shagirov Maksat on 03.05.2021.
//

import UIKit
import Foundation

class EditRecipeVC: UIViewController {
    
    var name: String?
    var time: String?
    var difficulty: String?
    var ingredients: String?
    var methods: String?
    var delegate: Editable?

    @IBOutlet weak var nameTextInput: UITextField!
    @IBOutlet weak var timeTextInput: UITextField!
    @IBOutlet weak var difficultyTextInput: UITextField!
    @IBOutlet weak var methodsTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextInput.text = name
        timeTextInput.text = time
        difficultyTextInput.text = difficulty
        ingredientsTextView.text = ingredients
        methodsTextView.text = methods
    }
    
    @IBAction func savePressed(_ sender: Any) {
        delegate?.editRecipe(nameTextInput.text!, timeTextInput.text!, difficultyTextInput.text!, ingredientsTextView.text!, methodsTextView.text!)
        self.dismiss(animated: true, completion: nil)
    }
}
