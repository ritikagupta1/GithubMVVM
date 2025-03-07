//
//  FavouritesListViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 07/03/25.
//

import Foundation
protocol FavouritesListViewModelProtocol {
    var delegate: FavouritesListViewModelDelegate? { get set }
    
    
    var networkManager: NetworkServiceProtocol { get }
    var persistenceManager: PersistenceManagerProtocol { get }
    
    func getRowCount() -> Int
    func getFavourites()
    func getFavourite(at index: Int) -> Follower
    func removeFavourites(at Index: Int)
}

class FavouritesListViewModel: FavouritesListViewModelProtocol {
    let persistenceManager: PersistenceManagerProtocol
    let networkManager: NetworkServiceProtocol
    
    weak var delegate: FavouritesListViewModelDelegate?
    
    private var favourites: [Follower] = []
    
    init(persistenceManager: PersistenceManagerProtocol, networkManager: NetworkServiceProtocol) {
        self.persistenceManager = persistenceManager
        self.networkManager = networkManager
    }
    
    func getRowCount() -> Int {
        return favourites.count
    }
    
    func getFavourites() {
        persistenceManager.retrieveFavourites { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let favourites):
                self.favourites = favourites
                delegate?.didUpdateFavourites(self.favourites)
        
            case .failure(let error):
                delegate?.didFailToFavouriteUser(with: error.rawValue)
            }
        }
    }
    
    func getFavourite(at index: Int) -> Follower {
        self.favourites[index]
    }
    
    func removeFavourites(at index: Int) {
        let favourite = self.favourites[index]
        persistenceManager.updateFavourites(actionType: .remove, favourite: favourite) { [weak self] error in
            guard let self = self else {
                return
            }
            guard let error = error else {
                self.favourites.remove(at: index)
                self.delegate?.didRemoveFavourite(at: index)
                return
            }
            
            self.delegate?.didFailToRemoveFavourite(with: error.rawValue)
        }
    }
}

protocol FavouritesListViewModelDelegate: AnyObject {
    func didUpdateFavourites(_ favourites: [Follower])
    func didFailToFavouriteUser(with errorMessage: String)
    
    func didRemoveFavourite(at rowIndex: Int)
    func didFailToRemoveFavourite(with errorMessage: String)
}
