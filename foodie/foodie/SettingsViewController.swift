//
//  SettingsViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 14.05.2021.
//

import UIKit
import LanguageManager_iOS

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeToEng(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .en)
    }
    
    @IBAction func changeToRus(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .ru)
    }
    @IBAction func changeToKaz(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .ko)
    }
}
