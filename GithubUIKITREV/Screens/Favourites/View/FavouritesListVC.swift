//
//  SecondViewController.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 04/03/25.
//

import UIKit

final class FavouritesListVC: GFDataLoadingVC {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80.0
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
        return tableView
    }()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getFavourites()
    }
    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.title = "Favourites"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension FavouritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID, for: indexPath) as? FavouriteCell else {
            return UITableViewCell()
        }
        let favouriteCellViewModel = self.viewModel.getFavouriteViewModel(at: indexPath.row)
        cell.set(with: favouriteCellViewModel)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFavouriteLogin = self.viewModel.getFavouriteLogin(at: indexPath.row)
        let vm = FollowerListViewModel(userName: selectedFavouriteLogin,
                                                  networkManager: NetworkManager(),
                                                  persistenceManager: PersistenceManager(),
                                                  imageLoader: ImageLoader())
        let destVC = FollowersListVC(viewModel: vm)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        self.viewModel.removeFavourites(at: indexPath.row)
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
        }
    }
    
    func didFailToRemoveFavourite(with errorMessage: String) {
        DispatchQueue.main.async {
            self.presentGFAlertViewController(title: Constants.unableToRemoveFavouriteUser, message: errorMessage, buttonTitle: Constants.ok)
        }
    }
    
}
