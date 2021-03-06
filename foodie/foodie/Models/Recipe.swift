import UIKit
import Foundation
import Firebase

class Recipe {
    var type : String?
    
    var name : String?
    var time : String?
    var difficulty : String?
    
    var ingredients : String?
    var methods : String?
    
    var imageName: String?
    var image : UIImage?
    
    var dict : [String : String] {
        return [
            "type": type!,
            "name" : name!,
            "time" : time!,
            "difficulty" : difficulty!,
            "ingredients" : ingredients!,
            "methods" : methods!,
            "imageName" : imageName!
        ]
    }

    init(name : String, time : String, type : String, methods : String, difficulty : String, ingredients : String, imageName: String) {
        self.name = name
        self.time = time
        self.type = type
        self.methods = methods
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.imageName = imageName
    }
    
    init(snapshot : DataSnapshot) {
        if let value = snapshot.value as? [String : String] {
            name = value["name"]
            time = value["time"]
            methods = value["methods"]
            ingredients = value["ingredients"]
            difficulty = value["difficulty"]
            type = value["type"]
            imageName = value["imageName"]
        }
    }
}
