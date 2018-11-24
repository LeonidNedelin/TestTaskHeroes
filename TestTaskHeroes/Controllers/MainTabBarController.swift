//
//  MainTabBar.swift
//  TestTaskHeroes
//
//  Created by leanid niadzelin on 11/22/18.
//  Copyright © 2018 Leanid Niadzelin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        tabBar.barTintColor = .mainRed
        tabBar.unselectedItemTintColor = UIColor.mainBackground.withAlphaComponent(0.3)
    }
    
    private func setupControllers() {
        let heroesController = HeroesController()
        let heroesNavController = templateNavController(rootViewController: heroesController, image: #imageLiteral(resourceName: "ic_users"))
        
        let favoriteHeroController = FavoriteHeroController()
        let favoriteHeroNavController = templateNavController(rootViewController: favoriteHeroController, image: #imageLiteral(resourceName: "ic_user"))
        
        viewControllers = [heroesNavController, favoriteHeroNavController]
        
        guard let items = tabBar.items else { return }
        items.forEach { (item) in
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func templateNavController(rootViewController: UIViewController, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        return navController
    }
}

