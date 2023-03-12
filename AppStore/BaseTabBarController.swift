//
//  BaseTabBarController.swift
//  AppStore
//
//  Created by Vladimir Kravets on 08.11.2022.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            createNavController(viewController: MusicController(), title: "Music", imageName: "music"),
            createNavController(viewController: TodayController(), title: "Today", imageName: "today"),
            createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search"),

        ]
    }
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
