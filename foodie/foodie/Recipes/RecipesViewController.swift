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
import LanguageManager_iOS
import DropDown

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var viewDropDown: UIView!
    @IBOutlet weak var sortLbl: UILabel!
    @IBOutlet weak var sortDropDownBtn: UIButton!
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recipesLabel: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    private let storage = Storage.storage().reference()
    let ref = Database.database().reference()
    
    var recipes : [Recipe] = []
    var showRecipes : [Recipe] = []
    var searchingRecipes: [Recipe] = []
    
    var favRecipes : [Recipe] = []
    var state = "breakfast"
    var curIdx = 0
    var currentUser: User?
   
    var isSearching = false
    
    let dropDown = DropDown()
    var sortingArr = ["Time it takes", "Easy recipes", "Medium recipes", "Hard recipes"]
    var language = LanguageManager.shared.currentLanguage.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropDown()
        
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.delegate = self
        
        currentUser = Auth.auth().currentUser
        
        myTableView.ourStyle()
        
        setUpSegmentController()
        
        loadRecipesFromFireBase()
    }
    
    func loadRecipesFromFireBase() {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self!.myTableView.reloadData()
            }
        }
    }
    
    func setUpSegmentController() {
        let font = UIFont.systemFont(ofSize: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "darkGreen")!], for: UIControl.State.normal)
    }
    
    func setUpDropDown(){
        dropDown.anchorView = viewDropDown
        sortingArr = ["Time it takes".addLocalizableString(str: language), "Easy recipes".addLocalizableString(str: language), "Medium recipes".addLocalizableString(str: language), "Hard recipes".addLocalizableString(str: language)]
        dropDown.dataSource = sortingArr
        dropDown.dismissMode = .automatic
        dropDown.textColor = UIColor(named: "darkGreen") ?? .black
        dropDown.cornerRadius = 20
    
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .any
        sortLbl.text = "Sort by:".addLocalizableString(str: language)
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            sortLbl.text = item.addLocalizableString(str: language)
            updateRecipes(sortType: index)
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    func updateRecipes(sortType: Int){
        language = LanguageManager.shared.currentLanguage.rawValue
        showRecipes.removeAll()
        searchingRecipes.removeAll()
        for recipe in recipes {
            if(state == "all" || recipe.type == state) {
                if(sortType == 1){
                    if(recipe.difficulty == "easy"){
                        showRecipes.append(recipe)
                    }
                } else if(sortType == 2){
                    if(recipe.difficulty == "medium"){
                        showRecipes.append(recipe)
                    }
                } else if(sortType == 3){
                    if(recipe.difficulty == "hard"){
                        showRecipes.append(recipe)
                    }
                } else if(sortType == 0){
                    showRecipes.append(recipe)
                    showRecipes.sort(by: {Int($0.time!)! < Int($1.time!)!})
                }
            }
        }
        getFavourites()
        myTableView.reloadData()
    }
    
    @IBAction func dropDownClicked(_ sender: UIButton) {
        dropDown.show()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchingRecipes.removeAll()
            isSearching = true
            if searchText == "" {
                isSearching = false;
            } else {
                for recipe in showRecipes {
                    if recipe.ingredients!.lowercased().range(of: searchText.lowercased()) != nil{
                        searchingRecipes.append(recipe)
                    }
                }
            }
            myTableView.reloadData()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
        updateLanguage(LanguageManager.shared.currentLanguage.rawValue)
    }
    
    func updateLanguage(_ language: String) {
        segmentedControl.setTitle("Breakfast".addLocalizableString(str: language), forSegmentAt: 0)
        segmentedControl.setTitle("Lunch".addLocalizableString(str: language), forSegmentAt: 1)
        segmentedControl.setTitle("Dinner".addLocalizableString(str: language), forSegmentAt: 2)
        segmentedControl.setTitle("All".addLocalizableString(str: language), forSegmentAt: 3)
        recipesLabel.text = "Recipes".addLocalizableString(str: language)
        label1.text = "Hey! What's in your fridge?".addLocalizableString(str: language)
        label2.text = "Type the ingredients and we'll show you recipes with them.".addLocalizableString(str: language)
        sortLbl.text = "Sort by:".addLocalizableString(str: language)
        dropDown.dataSource = ["Time it takes".addLocalizableString(str: language), "Easy recipes".addLocalizableString(str: language), "Medium recipes".addLocalizableString(str: language), "Hard recipes".addLocalizableString(str: language)]
//        setUpDropDown()
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
            if isFavourite == false {
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
        case 3: state = "all";
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
        sortLbl.text = "Sort by:".addLocalizableString(str: language)
        showRecipes.removeAll()
        searchingRecipes.removeAll()
        if(state != "all") {
            for recipe in recipes {
                if(recipe.type == state) {
                    showRecipes.append(recipe)
                }
            }
        } else {
            showRecipes = recipes
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
        let language = LanguageManager.shared.currentLanguage.rawValue
        
        if isSearching{
            cell?.name.text = searchingRecipes[indexPath.row].name
            cell?.time.text = "Time it takes".addLocalizableString(str: language) + ": " + searchingRecipes[indexPath.row].time!
            cell?.difficulty.text = "Level of difficulty".addLocalizableString(str: language) + ": " + searchingRecipes[indexPath.row].difficulty!.addLocalizableString(str: language)
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
            cell?.time.text = "Time it takes".addLocalizableString(str: language) + ": " + showRecipes[indexPath.row].time!
            cell?.difficulty.text = "Level of difficulty".addLocalizableString(str: language) + ": " + showRecipes[indexPath.row].difficulty!.addLocalizableString(str: language)
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

extension UITableView {
    func ourStyle() {
        self.separatorStyle = .none
        self.rowHeight = 350
    }
}
