//
//  AddRecipeVC.swift
//  foodie
//
//  Created by Эльвина on 03.05.2021.
//

import UIKit

class AddRecipeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var delegate: Addable?

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var levelPicker: UIPickerView!
    
    @IBOutlet weak var nameTextInput: UITextField!
    @IBOutlet weak var timeTextInput: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var methodsTextView: UITextView!
    
    var difficulty = "easy"
    var pickerData = ["easy", "medium", "hard"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.levelPicker.delegate = self
        self.levelPicker.dataSource = self
    }
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
   }
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
// The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        difficulty = pickerData[row]
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        delegate?.add(nameTextInput.text!, timeTextInput.text!, difficulty, ingredientsTextView.text!, methodsTextView.text!)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddRecipeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var img = UIImage()
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            recipeImageView.image = image
                    img = image
                }
        picker.dismiss(animated: true, completion: nil)
        
        guard let imageData = recipeImageView.image?.pngData() else{
            return
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

