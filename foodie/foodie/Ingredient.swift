//
//  Ingredient.swift
//  foodie
//
//  Created by Shagirov Maksat on 22.04.2021.
//

import Foundation
import UIKit
import Firebase

struct Ingredient {
    var recipeName : String?
    var name : String?
    var quantity : Int?
    
    var dict : [String : String] {
        return [
            "recipeName" : recipeName!,
            "name" : name!,
            "quantity" : String(quantity!)
        ]
    }
    
    init(_ recipeName : String, _ name : String, _ quantity : Int) {
        self.recipeName = recipeName
        self.name = name
        self.quantity = quantity
    }
    
    init(snapshot : DataSnapshot) {
        if let value = snapshot.value as? [String : String] {
            recipeName = value["recipeName"]
            name = value["name"]
            quantity = Int(value["quantity"]!) ?? 0
        }
    }
}
