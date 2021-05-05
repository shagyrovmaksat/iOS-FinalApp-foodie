//
//  EditRecipeVC.swift
//  foodie
//
//  Created by Shagirov Maksat on 03.05.2021.
//

import UIKit
import Foundation

class EditRecipeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    var name: String?
    var time: String?
    var difficulty: String?
    var ingredients: String?
    var methods: String?
    var delegate: Editable?

    @IBOutlet weak var nameTextInput: UITextField!
    @IBOutlet weak var timeTextInput: UITextField!
    @IBOutlet weak var methodsTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var difficultyPicker: UIPickerView!
    
    var pickerData = ["easy", "medium", "hard"]
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextInput.text = name
        timeTextInput.text = time
        
        self.difficultyPicker.delegate = self
        self.difficultyPicker.dataSource = self
        
        if let indexPosition = pickerData.firstIndex(of: difficulty!){
           difficultyPicker.selectRow(indexPosition, inComponent: 0, animated: true)
        }
        
        ingredientsTextView.text = ingredients
        methodsTextView.text = methods
    }

    @IBAction func savePressed(_ sender: Any) {
        delegate?.editRecipe(name!, nameTextInput.text!, timeTextInput.text!, difficulty!, ingredientsTextView.text!, methodsTextView.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        difficulty = pickerData[row]
    }
}
