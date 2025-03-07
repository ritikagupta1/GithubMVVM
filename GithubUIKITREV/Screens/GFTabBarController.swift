//
//  TabViewController.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 04/03/25.
//

import UIKit

class GFTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [createSearchVC(), createFavouriteVC()]
        UITabBar.appearance().tintColor = .systemGreen
    }

    private func createSearchVC() -> UINavigationController {
        let searchVC = ViewControllerFactory.makeSearchVC()
        searchVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        searchVC.title = "Search"
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavouriteVC() -> UINavigationController {
        let favouriteVC = ViewControllerFactory.makeFavouritesListVC()
        favouriteVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        favouriteVC.title = "Favourites"
        return UINavigationController(rootViewController: favouriteVC)
    }
}
