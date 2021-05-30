//
//  AddRecipeTempVC.swift
//  foodie
//
//  Created by Эльвина on 07.05.2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddRecipeTempVC: UIViewController {

    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeTime: UITextField!
    @IBOutlet weak var recipeType: UITextField!
    @IBOutlet weak var recipeLevel: UITextField!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeSteps: UITextView!
    @IBOutlet weak var recipeImageName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addRecipeToFirebase(_ sender: Any) {
        let newRecipe = Recipe(name: recipeName.text!, time: recipeTime.text!, type: recipeType.text!, methods: recipeSteps.text!, difficulty: recipeLevel.text!, ingredients: recipeIngredients.text!, imageName: recipeImageName.text!)
        
        Database.database().reference().child("recipes").childByAutoId().setValue(newRecipe.dict)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
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
