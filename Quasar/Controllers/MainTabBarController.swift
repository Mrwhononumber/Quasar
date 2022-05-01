//
//  MainTabBarController.swift
//  Quasar
//
//  Created by Basem El kady on 4/1/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    private let vc1 = UINavigationController(rootViewController: HomeViewController())
    private let vc2 = UINavigationController(rootViewController: FavoritesViewController())

    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
     setupTabBarViewControllers()
    }

    //MARK: - Helper functions
    
    func setupTabBarViewControllers() {
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        vc1.title = "Home"
        vc2.title = "Favorites"
        tabBar.tintColor = .systemPink
        setViewControllers([vc1,vc2], animated: true)
    }

}
