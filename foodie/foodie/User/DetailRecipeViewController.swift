//
//  DetailRecipeViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 03.05.2021.
//

import UIKit

class DetailRecipeViewController: UIViewController, Editable {
    var name: String?
    var time: String?
    var difficulty: String?
    var ingredients: String?
    var methods: String?
    var delegate: Editable?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var methodsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = name
        timeLabel.text = "Time it takes: " + time!
        difficultyLabel.text = "Level of difficulty: " + difficulty!
        ingredientsTextView.text = ingredients
        methodsTextView.text = methods
        ingredientsTextView.isEditable = false
        methodsTextView.isEditable = false
        
//        let attrs = [
//            NSAttributedString.Key.foregroundColor: UIColor(named: "darkGreen"),
//            NSAttributedString.Key.font: UIFont(name: name!, size: 20)
//        ]
//        self.navigationBar.titleTextAttributes = attrs as [NSAttributedString.Key : Any]
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
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func edit(name: String, surname: String) {
        return
    }
    
    func editRecipe(_ oldName: String, _ name: String, _ time: String, _ difficulty: String, _ ingredients: String, _ methods: String) {
        self.name = oldName
        navigationBar.topItem?.title = name
        timeLabel.text = "Time it takes: " + time
        difficultyLabel.text = "Level of difficulty: " + difficulty
        ingredientsTextView.text = ingredients
        methodsTextView.text = methods
        delegate?.editRecipe(oldName, name, time, difficulty, ingredients, methods)
    }
}
