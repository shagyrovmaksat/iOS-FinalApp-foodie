//
//  FavoritesViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 21.04.2021.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var myTableView: UITableView!
    private let storage = Storage.storage().reference()
    let ref = Database.database().reference()
    
    var recipes : [Recipe] = []
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: from recipe to detail
        currentUser = Auth.auth().currentUser
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 350
        
        Database.database().reference().child("users").child(currentUser!.uid).child("favoriteRecipes").observe(.value) { [weak self](snapshot) in
            self?.recipes.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let recipe = Recipe(snapshot: snap)
                    self?.recipes.append(recipe)
                }
            }
            //FIXME: images loading
            self?.recipes.reverse()
            self?.loadImages()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self!.myTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myFavCell") as? RecipesCustomCell
        
        cell?.name.text = recipes[indexPath.row].name
        cell?.time.text = recipes[indexPath.row].time
        cell?.difficulty.text = recipes[indexPath.row].difficulty
        cell?.recipeImage.image = recipes[indexPath.row].image
        
        
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
        self.myTableView.reloadData()
    }
    
    @IBAction func removeFromFavs(_ sender: UIButton) {
        let buttonPos = sender.convert(CGPoint.zero, to: self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: buttonPos)
        let usersRef = Database.database().reference().child("users").child(currentUser!.uid).child("favoriteRecipes")
        let queryRef = usersRef.queryOrdered(byChild: "name").queryEqual(toValue: self.recipes[indexPath!.row].name)
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let uid = userSnap.key
                Database.database().reference().child("users").child((self.currentUser!.uid)).child("favoriteRecipes/\(uid)").removeValue()
                print("key = \(uid)")
            }
        })
        self.recipes.remove(at: indexPath!.row)
        myTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let index = myTableView.indexPathForSelectedRow?.row {
            let destination = segue.destination as! RecipeDetailVC
            destination.nameText = recipes[index].name
            destination.timeText = recipes[index].time
            destination.difficultyText = recipes[index].difficulty
            destination.ingredientsText = recipes[index].ingredients
            destination.methodsText = recipes[index].methods
            destination.image = recipes[index].image
        }
    }
}
