//
//  SecondViewController.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 04/03/25.
//

import UIKit

class FavouritesListVC: GFDataLoadingVC {
    let tableView = UITableView()
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
        configureTableView()
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
    
    func configureTableView() {
        self.view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80.0
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
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
        let favouriteCellViewModel = FavouriteCellViewModel(
            networkManager: viewModel.networkManager,
            favourite: viewModel.getFavourite(at: indexPath.row))
        cell.set(with: favouriteCellViewModel)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFavourite = self.viewModel.getFavourite(at: indexPath.row)
        let destinationVC = ViewControllerFactory.makeFollowersListVC(with: selectedFavourite.login)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        self.viewModel.removeFavourites(at: indexPath.row)
    }
}

extension FavouritesListVC: FavouritesListViewModelDelegate {
    func didUpdateFavourites(_ favourites: [Follower]) {
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
                title: "Something went wrong",
                message: errorMessage,
                buttonTitle: "Ok")
        }
    }
    
    func didRemoveFavourite(at rowIndex: Int) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .left)
        }
    }
    
    func didFailToRemoveFavourite(with errorMessage: String) {
        DispatchQueue.main.async {
            self.presentGFAlertViewController(title: "Unable to remove the favourited user", message: errorMessage, buttonTitle: "ok")
        }
    }
    
}
