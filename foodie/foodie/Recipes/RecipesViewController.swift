//
//  RecipesViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 21.04.2021.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let storage = Storage.storage().reference()
    let ref = Database.database().reference()
    
    var recipes : [Recipe] = []
    var showRecipes : [Recipe] = []
    var state = "breakfast"

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 350
        let font = UIFont.systemFont(ofSize: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "darkGreen")!], for: UIControl.State.normal)
        
        ref.child("recipes").observe(.value) { [weak self](snapshot) in
            self?.recipes.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let tweet = Recipe(snapshot: snap)
                    self?.recipes.append(tweet)
                }
            }
            self?.recipes.reverse()
            self?.loadImages()
            self?.prepareRecipes()
        }
    }
    
    @IBAction func change(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: state = "breakfast";
        case 1: state = "lunch";
        case 2: state = "dinner";
        default: break;
        }
        prepareRecipes()
    }
    
    func loadImages() {
        for recipe in recipes {
            let imageRef = storage.child("recipesImages/\(recipe.imageName!).png")
            imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
              if error == nil {
                let image = UIImage(data: data!)
                recipe.image = image
              } else {
                print(error!)
              }
            }
        }
    }
    
    func prepareRecipes() {
        showRecipes.removeAll()
        for recipe in recipes {
            if(recipe.type == state) {
                showRecipes.append(recipe)
            }
        }
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? RecipesCustomCell
        
        cell?.name.text = showRecipes[indexPath.row].name
        cell?.time.text = showRecipes[indexPath.row].time
        cell?.difficulty.text = showRecipes[indexPath.row].difficulty
        cell?.recipeImage.image = showRecipes[indexPath.row].image
        
        cell?.contentView.layer.borderWidth = 2.0
        cell?.contentView.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        cell?.contentView.layer.cornerRadius = 10
        cell?.contentView.layer.shadowRadius = 10
        cell?.contentView.layer.shadowOpacity = 0.35
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
    }
}
