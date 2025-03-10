//
//  FavouritesListDelegateHandler.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 10/03/25.
//

import UIKit
final class FavouritesListDelegateHandler: NSObject, FavouritesListViewModelDelegate {
    
    private weak var viewModel: FavouritesListViewModelProtocol?
    private weak var parentViewController: FavouritesListVC?
    private weak var tableViewManager: FavouritesListTableViewManager?
    
    
    init(tableViewManager: FavouritesListTableViewManager, viewModel: FavouritesListViewModelProtocol, parentViewController: FavouritesListVC) {
        super.init()
        self.tableViewManager = tableViewManager
        self.viewModel = viewModel
        self.parentViewController = parentViewController
        viewModel.delegate = self
    }
    
    func didUpdateFavourites(_ favourites: [FavouriteViewModel]) {
        DispatchQueue.main.async {
            self.tableViewManager?.reloadData()
            parentViewController?.view?.bringSubviewToFront(self.parentViewController!.tableView)
            if favourites.isEmpty {
                parentViewController.showEmptyStateView(with: Constants.noFavourites)
            }
        }
    }
    
    func didFailToFavouriteUser(with errorMessage: String) {
        DispatchQueue.main.async {
            self.parentViewController?.presentGFAlertViewController(
                title: Constants.somethingWentWrongTitle,
                message: errorMessage,
                buttonTitle: Constants.ok)
        }
    }
    
    func didRemoveFavourite(at rowIndex: Int) {
        DispatchQueue.main.async {
            self.tableViewManager?.deleteRow(at: rowIndex)
            if self.viewModel?.getRowCount() == 0 { self.parentViewController?.showEmptyStateView(with: Constants.noFavourites) }
        }
    }
    
    func didFailToRemoveFavourite(with errorMessage: String) {
        DispatchQueue.main.async {
            self.parentViewController?.presentGFAlertViewController(title: Constants.unableToRemoveFavouriteUser, message: errorMessage, buttonTitle: Constants.ok)
        }
    }
}
