//
//  MainPageVC.swift
//  foodie
//
//  Created by Эльвина on 25.05.2021.
//

import UIKit

class MainPageVC: UIPageViewController {

    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([viewControllerList[0]], direction: .forward, animated: false, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    private var viewControllerList: [UIViewController] = {
        let storyboard = UIStoryboard.onboarding
        let firstVC = storyboard.instantiateViewController(withIdentifier: "FirstStepVC")
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondStepVC")
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdStepVC")
        return [firstVC, secondVC, thirdVC]
    }()
    
    func pushNext() {
        if currentIndex + 1 < viewControllerList.count {
          self.setViewControllers([self.viewControllerList[self.currentIndex + 1]], direction: .forward, animated: true, completion: nil)
            currentIndex += 1
        }
    }
}
