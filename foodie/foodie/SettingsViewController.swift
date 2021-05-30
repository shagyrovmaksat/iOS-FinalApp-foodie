//
//  SettingsViewController.swift
//  foodie
//
//  Created by Shagirov Maksat on 14.05.2021.
//

import UIKit
import LanguageManager_iOS

class SettingsViewController: UIViewController {

    @IBOutlet weak var engButton: UIButton!
    @IBOutlet weak var rusButton: UIButton!
    @IBOutlet weak var kazButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeToEng(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .en)
        updateLanguage(LanguageManager.shared.currentLanguage.rawValue)
    }
    @IBAction func changeToRus(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .ru)
        updateLanguage(LanguageManager.shared.currentLanguage.rawValue)
    }
    @IBAction func changeToKaz(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .ko)
        updateLanguage("ko")
    }
    
    func updateLanguage(_ language: String) {
        settingsLabel.text = "Settings".addLocalizableString(str: language)
        label1.text = "Choose your language".addLocalizableString(str: language)
        backButton.setTitle("Back".addLocalizableString(str: language), for: .normal)
    }
}

extension String {
    
    func addLocalizableString(str: String) -> String {
        let path = Bundle.main.path(forResource: str, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
