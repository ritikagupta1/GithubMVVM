//
//  TabViewController.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 04/03/25.
//

import UIKit

final class GFTabBarController: UITabBarController {
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
        let searchVC = SearchViewController()
        searchVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        searchVC.title = Constants.search
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavouriteVC() -> UINavigationController {
        let favouritesViewModel = FavouritesListViewModel(
            persistenceManager: PersistenceManager(),
            networkManager: NetworkManager())
        let favouriteVC = FavouritesListVC(viewModel: favouritesViewModel)
        favouriteVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        favouriteVC.title = Constants.favourites
        return UINavigationController(rootViewController: favouriteVC)
    }
}
