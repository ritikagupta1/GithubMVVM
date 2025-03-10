//
//  FavouritesListViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 07/03/25.
//

import Foundation
protocol FavouritesListViewModelProtocol: AnyObject {
    var delegate: FavouritesListViewModelDelegate? { get set }
    
    var imageLoader: ImageLoaderProtocol { get }
    var persistenceManager: PersistenceManagerProtocol { get }
    
    func getRowCount() -> Int
    func getFavourites()
    func getFavouriteViewModel(at index: Int) -> FavouriteViewModel
    func getFavouriteLogin(at index: Int) -> String
    func removeFavourites(at Index: Int)
}

final class FavouritesListViewModel: FavouritesListViewModelProtocol {
    let persistenceManager: PersistenceManagerProtocol
    let imageLoader: ImageLoaderProtocol
    
    weak var delegate: FavouritesListViewModelDelegate?
    
    var favourites: [FavouriteViewModel] = []
    
    init(persistenceManager: PersistenceManagerProtocol, imageLoader: ImageLoaderProtocol) {
        self.persistenceManager = persistenceManager
        self.imageLoader = imageLoader
    }
    
    func getRowCount() -> Int {
        return favourites.count
    }
    
    func getFavourites() {
        let result = persistenceManager.retrieveFavourites()
        switch result {
        case .success(let favourites):
            self.favourites = favourites.map{ FavouriteViewModel(imageLoader: self.imageLoader, favourite:$0 )}
            delegate?.didUpdateFavourites(self.favourites)
            
        case .failure(let error):
            delegate?.didFailToFavouriteUser(with: error.rawValue)
        }
    }
    
    func getFavouriteViewModel(at index: Int) -> FavouriteViewModel {
        self.favourites[index]
    }
    
    func getFavouriteLogin(at index: Int) -> String {
        self.favourites[index].favourite.login
    }
    
    func removeFavourites(at index: Int) {
        let favourite = self.favourites[index].favourite
        if let error = persistenceManager.updateFavourites(actionType: .remove, favourite: favourite) {
            self.delegate?.didFailToRemoveFavourite(with: error.rawValue)
        } else {
            self.favourites.remove(at: index)
            self.delegate?.didRemoveFavourite(at: index)
        }
    }
}

protocol FavouritesListViewModelDelegate: AnyObject {
    func didUpdateFavourites(_ favourites: [FavouriteViewModel])
    func didFailToFavouriteUser(with errorMessage: String)
    
    func didRemoveFavourite(at rowIndex: Int)
    func didFailToRemoveFavourite(with errorMessage: String)
}
