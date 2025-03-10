//
//  FavouritesListTableViewManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 10/03/25.
//

import UIKit

final class FavouritesListTableViewManager: NSObject {
    var tableView: UITableView
    var viewModel: FavouritesListViewModelProtocol
    var parentViewController: FavouritesListVC
    
    init(tableView: UITableView, viewModel: FavouritesListViewModelProtocol, parentViewController: FavouritesListVC) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.parentViewController = parentViewController
        super.init()
        self.configureTableView()
    }
    
    private func configureTableView() {
        tableView.frame = parentViewController.view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80.0
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
        
    func deleteRow(at rowIndex: Int) {
        tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .left)
    }
}

// MARK: - UITableViewDataSource
extension FavouritesListTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID, for: indexPath) as? FavouriteCell else { return UITableViewCell()}
        let favouriteCellViewModel = viewModel.getFavouriteViewModel(at: indexPath.row)
        cell.set(with: favouriteCellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.removeFavourites(at: indexPath.row)
    }
}

// MARK: - UITableViewDelegate
extension FavouritesListTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = parentViewController.navigationController else { return }
        let selectedFavouriteLogin = viewModel.getFavouriteLogin(at: indexPath.row)
        let vm = FollowerListViewModel(userName: selectedFavouriteLogin,
                                      networkManager: NetworkManager(),
                                      persistenceManager: PersistenceManager(),
                                      imageLoader: ImageLoader())
        let destVC = FollowersListVC(viewModel: vm)
        navigationController.pushViewController(destVC, animated: true)
    }
}
