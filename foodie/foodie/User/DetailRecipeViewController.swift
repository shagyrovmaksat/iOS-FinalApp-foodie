//
//  DetailRecipeViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 03.05.2021.
//

import UIKit
import LanguageManager_iOS

class DetailRecipeViewController: UIViewController, Editable {
    var name: String?
    var time: String?
    var difficulty: String?
    var ingredients: String?
    var methods: String?
    var image: UIImage?
    var ind: Int?
    var delegate: Editable?
    var delegateForChange: Changeable?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var methodsTextView: UITextView!
    @IBOutlet weak var recipeName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        recipeName.text = name
        let language = LanguageManager.shared.currentLanguage.rawValue
        timeLabel.text = "Time it takes".addLocalizableString(str: language) + ": " + time!
        difficultyLabel.text = "Level of difficulty".addLocalizableString(str: language) + ": " + difficulty!.addLocalizableString(str: language)
        ingredientsTextView.text = ingredients
        methodsTextView.text = methods
        ingredientsTextView.isEditable = false
        methodsTextView.isEditable = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditRecipeVC{
            destination.delegate = self
            destination.name = name
            destination.time = time
            destination.difficulty = difficulty
            destination.ingredients = ingredients
            destination.methods = methods
            destination.delegate = self
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func edit(name: String, surname: String) {
        return
    }
    
    func editRecipe(_ image: UIImage, _ oldName: String, _ name: String, _ time: String, _ difficulty: String, _ ingredients: String, _ methods: String) {
        self.name = oldName
        recipeName.text = name
        timeLabel.text = "Time it takes".addLocalizableString(str: LanguageManager.shared.currentLanguage.rawValue) + ": " + time
        difficultyLabel.text = "Level of difficulty".addLocalizableString(str: LanguageManager.shared.currentLanguage.rawValue) + ": " + difficulty
        ingredientsTextView.text = ingredients
        methodsTextView.text = methods
        delegate?.editRecipe(imageView.image!, oldName, name, time, difficulty, ingredients, methods)
    }
    
    @IBAction func changeImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension DetailRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image
            delegateForChange?.change(ind!, image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
