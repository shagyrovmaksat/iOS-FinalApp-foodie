//
//  RecipeDetailVC.swift
//  foodie
//
//  Created by Shagirov Maksat on 09.05.2021.
//

import UIKit

class RecipeDetailVC: UIViewController {
    
    var nameText : String?
    var timeText : String?
    var difficultyText : String?
    var ingredientsText : String?
    var methodsText : String?
    var image : UIImage?
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var methodsTV: UITextView!
    @IBOutlet weak var ingredientsTV: UITextView!
    @IBOutlet weak var viewWithCorner: UIView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWithCorner.layer.cornerRadius = 5
        viewWithCorner.layer.borderWidth = 3
        viewWithCorner.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        navBar.barTintColor = UIColor(named: "darkGreen")
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        recipeImage.image = image
        name.text = nameText
        time.text = "Time it takes: " + timeText!
        difficulty.text = "Level of difficulty: " + difficultyText!
        methodsTV.text = methodsText
        ingredientsTV.text = ingredientsText
        ingredientsTV.isEditable = false
        methodsTV.isEditable = false
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
