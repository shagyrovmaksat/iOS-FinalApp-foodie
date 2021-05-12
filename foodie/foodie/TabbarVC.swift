//
//  TabbarVC.swift
//  foodie
//
//  Created by Эльвина on 06.05.2021.
//

import UIKit
import RAMAnimatedTabBarController

class TabbarVC: RAMAnimatedTabBarController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = UIColor.init(named: "darkGreen")
        tabBar.tintColor = UIColor.init(named: "lightGreen")
        
        configure()
    }
    
    func configure(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userVC = storyboard.instantiateViewController(withIdentifier: "UserInfoViewController")
        let favVC = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController")
        let recipesVC = storyboard.instantiateViewController(withIdentifier: "RecipesViewController")
        userVC.tabBarItem = RAMAnimatedTabBarItem(title: "", image: UIImage.init(named: "tabbar2"), tag: 1)
        (userVC.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMLeftRotationAnimation()
        
        favVC.tabBarItem = RAMAnimatedTabBarItem(title: "", image: UIImage.init(named: "tabbar3"), tag: 2)
        (favVC.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMRightRotationAnimation()
        
        recipesVC.tabBarItem = RAMAnimatedTabBarItem(title: "", image: UIImage.init(named: "tabbar1"), tag: 3)
        (recipesVC.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
        
        setViewControllers([userVC, recipesVC, favVC], animated: false)
    }


}
