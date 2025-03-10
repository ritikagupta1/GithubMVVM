//
//  FollowersListSearchManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 10/03/25.
//

import UIKit
final class FollowerListSearchManager: NSObject, UISearchResultsUpdating {
    let collectionView: UICollectionView
    let parentViewController: FollowersListVC
    let viewModel: FollowerListViewModelProtocol
    
    
    init(collectionView: UICollectionView, parentViewController: FollowersListVC, viewModel: FollowerListViewModelProtocol) {
        self.collectionView = collectionView
        self.parentViewController = parentViewController
        self.viewModel = viewModel
        super.init()
        
        self.configureSearchManager()
    }
    
    func configureSearchManager() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Constants.userName
        
        parentViewController.navigationItem.searchController = searchController
        parentViewController.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            viewModel.resetSearch()
            return
        }
        
        viewModel.filterFollowers(with: searchText)
    }
}
