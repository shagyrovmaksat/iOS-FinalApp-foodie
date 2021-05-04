//
//  AddRecipeVC.swift
//  foodie
//
//  Created by Эльвина on 03.05.2021.
//

import UIKit

class AddRecipeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var levelPicker: UIPickerView!
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.levelPicker.delegate = self
        self.levelPicker.dataSource = self
        pickerData = ["easy", "medium", "hard"]
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
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
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

