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
import FirebaseAuth

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let storage = Storage.storage().reference()
    let ref = Database.database().reference()
    
    var recipes : [Recipe] = []
    var showRecipes : [Recipe] = []
    var favRecipes : [Recipe] = []
    var state = "breakfast"
    var curIdx = 0
    var currentUser: User?
    var searchingRecipes: [Recipe] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: check if is fav and change image
        // TODO: from recipe to detail
        searchBar.delegate = self
        currentUser = Auth.auth().currentUser
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 350
        let font = UIFont.systemFont(ofSize: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "darkGreen")!], for: UIControl.State.normal)
        ref.child("recipes").observe(.value) { [weak self](snapshot) in
            self?.recipes.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let recipe = Recipe(snapshot: snap)
                    self?.recipes.append(recipe)
                }
            }
            self?.recipes.reverse()
            self?.loadImages()
            self?.prepareRecipes()
            // FIXME: images loading
            // TODO: indicator for images
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self!.myTableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchingRecipes.removeAll()
            for recipe in showRecipes {
                print(searchText.lowercased())
                if recipe.ingredients!.lowercased().range(of: searchText.lowercased()) != nil{
                    searchingRecipes.append(recipe)
                }
            }
            isSearching = true
            if searchText == "" {
                isSearching = false;
            }
            myTableView.reloadData()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    func getFavourites(){
        Database.database().reference().child("users").child(currentUser!.uid).child("favoriteRecipes").observe(.value) { [weak self](snapshot) in
            self?.favRecipes.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let recipe = Recipe(snapshot: snap)
                    self?.favRecipes.append(recipe)
                }
            }
        }
    }
    
    
    @IBAction func addToFavs(_ sender: UIButton) {
        let buttonPos = sender.convert(CGPoint.zero, to: self.myTableView)
        guard let cell = sender.superview?.superview as? RecipesCustomCell else {
            return // or fatalError() or whatever
        }
        let indexPath = self.myTableView.indexPathForRow(at: buttonPos)
        var isFavourite = false
        let usersRef = Database.database().reference().child("users").child(currentUser!.uid).child("favoriteRecipes")
        let queryRef = usersRef.queryOrdered(byChild: "name").queryEqual(toValue: self.showRecipes[indexPath!.row].name)
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                isFavourite = true
                let uid = userSnap.key
                cell.icon.setImage(UIImage.init(named: "notFav"), for: .normal)
                Database.database().reference().child("users").child((self.currentUser!.uid)).child("favoriteRecipes/\(uid)").removeValue()
                print("key = \(uid)")
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            if isFavourite == false{
                cell.icon.setImage(UIImage.init(named: "isFav"), for: .normal)
                Database.database().reference().child("users").child(self.currentUser!.uid).child("favoriteRecipes").childByAutoId().setValue(self.showRecipes[indexPath!.row].dict)
                print("added")
            }
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
        searchingRecipes.removeAll()
        for recipe in recipes {
            if(recipe.type == state) {
                showRecipes.append(recipe)
            }
        }
        getFavourites()
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return searchingRecipes.count
        }
        return showRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? RecipesCustomCell
        
        if isSearching{
            cell?.name.text = searchingRecipes[indexPath.row].name
            cell?.time.text = "Time it takes: " + searchingRecipes[indexPath.row].time!
            cell?.difficulty.text = "Level of difficulty: " + searchingRecipes[indexPath.row].difficulty!
            cell?.recipeImage.image = searchingRecipes[indexPath.row].image
            
            var isFav = false
            for recipe in favRecipes{
                if recipe.name == searchingRecipes[indexPath.row].name{
                    isFav = true
                }
            }
            if isFav{ cell?.icon.setImage(UIImage.init(named: "isFav"), for: .normal) }
            else{ cell?.icon.setImage(UIImage.init(named: "notFav"), for: .normal) }
            isFav = false
        }
        else{
            cell?.name.text = showRecipes[indexPath.row].name
            cell?.time.text = "Time it takes: " + showRecipes[indexPath.row].time!
            cell?.difficulty.text = "Level of difficulty: " + showRecipes[indexPath.row].difficulty!
            cell?.recipeImage.image = showRecipes[indexPath.row].image
            
            var isFav = false
            for recipe in favRecipes{
                if recipe.name == showRecipes[indexPath.row].name{
                    isFav = true
                }
            }
            if isFav{ cell?.icon.setImage(UIImage.init(named: "isFav"), for: .normal) }
            else{ cell?.icon.setImage(UIImage.init(named: "notFav"), for: .normal) }
            isFav = false
        }
        cell?.contentView.layer.borderWidth = 2.0
        cell?.contentView.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        cell?.contentView.layer.cornerRadius = 10
        cell?.contentView.layer.shadowRadius = 10
        cell?.contentView.layer.shadowOpacity = 0.35
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        curIdx = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let index = myTableView.indexPathForSelectedRow?.row {
            let destination = segue.destination as! RecipeDetailVC
            destination.nameText = showRecipes[index].name
            destination.timeText = showRecipes[index].time
            destination.difficultyText = showRecipes[index].difficulty
            destination.ingredientsText = showRecipes[index].ingredients
            destination.methodsText = showRecipes[index].methods
            destination.image = showRecipes[index].image
        }
    }
}
