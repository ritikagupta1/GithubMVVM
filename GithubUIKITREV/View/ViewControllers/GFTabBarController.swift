//
//  TabViewController.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 04/03/25.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [createSearchVC(), createFavouriteVC()]
        UITabBar.appearance().tintColor = .systemGreen
    }

    private func createSearchVC() -> UINavigationController {
        let searchVC = SearchViewController()
        searchVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        searchVC.title = "Search"
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavouriteVC() -> UINavigationController {
        let favouriteVC = FavouriteViewController()
        favouriteVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        favouriteVC.title = "Favourites"
        return UINavigationController(rootViewController: favouriteVC)
    }
}
