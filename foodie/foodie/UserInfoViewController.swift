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

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var myRecipes: [Recipe] = [Recipe(author: "Elvina", name: "Baked vegetables", time: 15, type: "Lunch", description: "tasty easy hehe", cookingMethod: "you need to cook it idk how", difficulty: "Easy", image: UIImage.init(named: "logo")!, ingredients: [])]
    var currentUser: User?
    
    private let storage = Storage.storage().reference()
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentUser = Auth.auth().currentUser
        // loading user's recipes
//        let parent = Database.database().reference().child("recipes")
//        parent.observe(.value) { [weak self] (snapshot) in
//            self?.myRecipes.removeAll()
//            for child in snapshot.children{
//                if let snap = child as? DataSnapshot{
//                    let recipe = Recipe(snapshot: snap)
//                    if recipe.author == self?.currentUser?.email{
//                        self?.myRecipes.append(recipe)
//                    }
//                }
//            }
//            self?.myRecipes.reverse()
//            self?.myTableView.reloadData()
//        }
        
        // fix height
        myTableView.rowHeight = 350
        
        // loading current user
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let surname = value?["surname"] as? String ?? ""
            let nameSurnameArr = [name, surname]
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
        cell?.imageView?.image = myRecipes[indexPath.row].image
//        print(cell?.imageView?.image?.size.height)
        cell?.recipeName.text = myRecipes[indexPath.row].name
        cell?.recipeTime.text = String(myRecipes[indexPath.row].time!)
        cell?.recipeLevel.text = myRecipes[indexPath.row].difficulty
        
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.green.cgColor
        cell?.contentView.layer.cornerRadius = 10
        cell?.contentView.layer.shadowRadius = 10
        cell?.contentView.layer.shadowOpacity = 0.35
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
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

