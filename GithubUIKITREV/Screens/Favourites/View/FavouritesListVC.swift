//
//  SecondViewController.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 04/03/25.
//

import UIKit
/*
 - Class can be final.
 - ViewController is overpopulated with responsibilities of handling tableview. Looks for a way to move it out of the viewcontroller.
 - Why is getFavourties called in viewwillappear? - so that favourites are fetched when screen appeears to show latest set of favourites
 - Why is favouriteCellViewModel created everytime in cellforrow method - Blunder.
 */

final class FavouritesListVC: GFDataLoadingVC {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        self.view.addSubview(tableView)
        return tableView
    }()
    
    private var tableViewManager: FavouritesListTableViewManager?
    
    var viewModel: FavouritesListViewModelProtocol
    
    init(viewModel: FavouritesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableViewManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getFavourites()
    }
    
    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.title = Constants.favourites
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableViewManager() {
        tableViewManager = FavouritesListTableViewManager(
            tableView: tableView,
            viewModel: viewModel,
            parentViewController: self
        )
    }
}

extension FavouritesListVC: FavouritesListViewModelDelegate {
    func didUpdateFavourites(_ favourites: [FavouriteViewModel]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
            if favourites.isEmpty {
                self.showEmptyStateView(with: Constants.noFavourites)
            }
        }
    }
    
    func didFailToFavouriteUser(with errorMessage: String) {
        DispatchQueue.main.async {
            self.presentGFAlertViewController(
                title: Constants.somethingWentWrongTitle,
                message: errorMessage,
                buttonTitle: Constants.ok)
        }
    }
    
    func didRemoveFavourite(at rowIndex: Int) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .left)
            if self.viewModel.getRowCount() == 0 { self.showEmptyStateView(with: Constants.noFavourites) }
        }
    }
    
    func didFailToRemoveFavourite(with errorMessage: String) {
        DispatchQueue.main.async {
            self.presentGFAlertViewController(title: Constants.unableToRemoveFavouriteUser, message: errorMessage, buttonTitle: Constants.ok)
        }
    }
}
