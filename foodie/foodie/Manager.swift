//
//  Manager.swift
//  foodie
//
//  Created by Эльвина on 25.05.2021.
//

import Foundation
class Manager {
    static let shared = Manager()
    
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
}
