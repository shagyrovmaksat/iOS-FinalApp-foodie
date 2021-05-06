//
//  Editable.swift
//  foodie
//
//  Created by Эльвина on 29.04.2021.
//

import Foundation
import UIKit

protocol Editable {
    func edit(name: String, surname: String)
    func editRecipe(_ image: UIImage, _ oldName: String, _ name: String,_ time: String,_ difficulty: String,_ ingredients: String,_ methods: String)
}
