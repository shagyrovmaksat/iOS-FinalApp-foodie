//
//  UserInfoViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 21.04.2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase
import CoreData

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Editable, Addable {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var addButton: UIButton!

    var myRecipes: [NSManagedObject] = []

    var currentUser: User?
    var nameSurnameArr: [String] = []
    
    private let storage = Storage.storage().reference()
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MyRecipe")
        
        do {
            myRecipes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error). \(error.userInfo)")
        }

        currentUser = Auth.auth().currentUser
        
        
        // fix height
        myTableView.rowHeight = 350
        myTableView.separatorStyle = .none
        addButton.layer.cornerRadius = 5
        // loading current user
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { [self] (snapshot) in
          // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let surname = value?["surname"] as? String ?? ""
            nameSurnameArr = [name, surname]
            self.nameSurname.text = nameSurnameArr[0] + " " + nameSurnameArr[1]
          }) { (error) in
            print(error.localizedDescription)
        }
        
        // loading profile photo
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
            let url = URL(string: urlString) else {
                return
            }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async { // to make sure that UI is updated as soon as we get the response
                let image = UIImage(data: data)
                self.myImageView.image = image
            }
        })
        task.resume()
        self.navBar.topItem?.title = currentUser?.email
    }
    
    @IBAction func photoPicker(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? ProfileRecipeCell
//        cell?.recipeImage.image = myRecipes[indexPath.row].image
// //        print(cell?.imageView?.image?.size.height)
        cell?.recipeName.text = myRecipes[indexPath.row].value(forKey: "name") as? String
        cell?.recipeTime.text = myRecipes[indexPath.row].value(forKey: "time") as? String
        cell?.recipeLevel.text = myRecipes[indexPath.row].value(forKey: "difficulty") as? String
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [self] (contextualAction, view, boolValue) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            managedContext.delete(myRecipes[indexPath.row])
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error). \(error.userInfo)")
            }
        
            myRecipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            myTableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor(named: "darkGreen")
            
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func edit(name: String, surname: String) {
        self.ref.child("users/\(Auth.auth().currentUser!.uid)/name").setValue(name)
        self.ref.child("users/\(Auth.auth().currentUser!.uid)/surname").setValue(surname)
        self.nameSurname.text = name + " " + surname
    }
    
    func add(_ name: String, _ time: String, _ difficulty: String, _ ingredients: String, _ methods: String) {
        save(name, time, difficulty, ingredients, methods)
        myTableView.reloadData()
    }
    
    func save(_ name: String, _ time: String, _ difficulty: String, _ ingredients: String, _ methods: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyRecipe", in: managedContext)!
        let recipe = NSManagedObject(entity: entity, insertInto: managedContext)
        
        recipe.setValue(name, forKey: "name")
        recipe.setValue(time, forKey: "time")
        recipe.setValue(difficulty, forKey: "difficulty")
        recipe.setValue(ingredients, forKey: "ingredients")
        recipe.setValue(methods, forKey: "methods")
        do {
            try managedContext.save()
            myRecipes.append(recipe)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func editRecipe(_ oldName: String, _ name: String, _ time: String, _ difficulty: String, _ ingredients: String, _ methods: String) {
        
        let indexInMyRecipes = myRecipes.firstIndex(where: { ($0.value(forKey: "name") as! String) == oldName})!
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(myRecipes[indexInMyRecipes])
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error). \(error.userInfo)")
        }
        myRecipes.remove(at: indexInMyRecipes)
        save(name, time, difficulty, ingredients, methods)
        myTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditProfileVC{
            destination.delegate = self
            nameSurnameArr = self.nameSurname.text?.components(separatedBy: " ") ?? [""]
            destination.name = self.nameSurnameArr[0]
            destination.surname = self.nameSurnameArr[1]
        }
        
        if let destination = segue.destination as? AddRecipeVC{
            destination.delegate = self
        }
        
        if let index = myTableView.indexPathForSelectedRow?.row {
            let destination = segue.destination as! DetailRecipeViewController
            destination.name = myRecipes[index].value(forKey: "name") as? String
            destination.time = myRecipes[index].value(forKey: "time") as? String
            destination.difficulty = myRecipes[index].value(forKey: "difficulty") as? String
            destination.ingredients = myRecipes[index].value(forKey: "ingredients") as? String
            destination.methods = myRecipes[index].value(forKey: "methods") as? String
            destination.delegate = self
        }
    }
}

extension UserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var img = UIImage()
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
                    myImageView.image = image
                    img = image
                }
        picker.dismiss(animated: true, completion: nil)
        
        guard let imageData = myImageView.image?.pngData() else{
            return
        }
        
        storage.child("images/\(self.currentUser?.uid ?? "file").png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self.storage.child("images/\(self.currentUser?.uid ?? "file").png").downloadURL { url, error in
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteString
                
                DispatchQueue.main.async {
                    self.myImageView.image = img
                }
                
                print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
