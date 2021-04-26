//
//  Recipe.swift
//  foodie
//
//  Created by Shagirov Maksat on 22.04.2021.
//
import UIKit
import Foundation
import Firebase

class Recipe {
    var author : String?
    var name : String?
    var time : Int?
    var description : String?
    var cookingMethod : String?
    var difficulty : String?
    var type : String?
    var listOfIngredients : [Ingredient] = []
    
    var image : UIImage?
    
    var dict : [String : String] {
        return [
            "author" : author!,
            "name" : name!,
            "time" : String(time!),
            "description" : description!,
            "cookingMethod" : cookingMethod!,
            "difficulty" : difficulty!,
            "type": type!
        ]
    }
    
    func fillIngredients() {
        //observe database and get ingredients with recipeName = self.name
        //fill listOfIngredients
    }
    
    func setImage(_ nameOfImage : String) {
        //get from storage by uid
    }
    
    init(author : String, name : String, time : Int, type : String , description : String, cookingMethod : String, difficulty : String, image : UIImage, ingredients listOfIngredients : [Ingredient]) {
        self.author = author
        self.name = name
        self.time = time
        self.type = type
        self.description = description
        self.cookingMethod = cookingMethod
        self.difficulty = difficulty
        self.image = image
        self.listOfIngredients = listOfIngredients
    }
    
    init(snapshot : DataSnapshot) {
        if let value = snapshot.value as? [String : String] {
            author = value["author"]
            name = value["name"]
            time = Int(value["author"]!) ?? 0
            cookingMethod = value["cookingMethod"]
            description = value["description"]
            difficulty = value["difficulty"]
            type = value["type"]
        }
        fillIngredients()
    }
}
