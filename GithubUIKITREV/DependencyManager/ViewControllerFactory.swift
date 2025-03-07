//
//  ViewControllerFactory.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 07/03/25.
//

import Foundation
class ViewControllerFactory {
    static let dependencyProvider: DependencyProvider = AppDependencyProvider()
    
    
    static func makeGFTabBarController() -> GFTabBarController {
        GFTabBarController()
    }
    
    static func makeSearchVC() -> SearchViewController {
        SearchViewController()
    }
    
    static func makeFavouritesListVC() -> FavouritesListVC {
        let viewModel = FavouritesListViewModel(
            persistenceManager: dependencyProvider.persistenceService,
            networkManager: dependencyProvider.networkService)
        return FavouritesListVC(viewModel: viewModel)
    }
    
    static func makeFollowersListVC(with userName: String) -> FollowersListVC {
       let viewModel = FollowerListViewModel(
            userName: userName,
            networkManager: dependencyProvider.networkService,
            persistenceManager: dependencyProvider.persistenceService)
        return FollowersListVC(viewModel: viewModel)
    }
    
    static func makeUserInfoVC(userName: String) -> GFUserInfoVC {
        let userInfoViewModel = GFUserInfoViewModel(userName: userName, networkManager: dependencyProvider.networkService)
        return GFUserInfoVC(viewModel: userInfoViewModel)
    }
    
    static func makeUserInfoHeaderVC(with user: User) -> GFUserInfoHeaderVC {
        let userInfoHeaderVC = GFUserInfoHeaderVC(
            viewModel: GFUserInfoHeaderViewModel(
                networkManager: dependencyProvider.networkService,
                user: user))
        return userInfoHeaderVC
    }
}
