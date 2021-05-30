//
//  RecipeDetailVC.swift
//  foodie
//
//  Created by Shagirov Maksat on 09.05.2021.
//

import UIKit
import LanguageManager_iOS

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
    @IBOutlet weak var viewWithCorner1: UIView!
    @IBOutlet weak var viewWithCorner2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        recipeImage.addGestureRecognizer(tapGestureRecognizer)
        viewWithCorner1.myCorner()
        viewWithCorner2.myCorner()
        recipeImage.image = image
        name.text = nameText
        let language = LanguageManager.shared.currentLanguage.rawValue
        time.text = "Time it takes".addLocalizableString(str: language) + ": " + timeText!
        difficulty.text = "Level of difficulty".addLocalizableString(str: language) + ": " + difficultyText!.addLocalizableString(str: language)
        methodsTV.text = methodsText
        ingredientsTV.text = ingredientsText
        ingredientsTV.isEditable = false
        methodsTV.isEditable = false
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imageView = tapGestureRecognizer.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = UIColor(named: "lightGreen")
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}

extension UIView {
    func myCorner() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(named: "lightGreen")?.cgColor
    }
}
