//
//  PersistenceManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 07/03/25.
//

import Foundation
enum PersistenceManagerAction {
    case add
    case remove
}

/*
 - Why is retrieveFavourites asynchronous?
 - Because of which updateFavourites is also asynchronous?
 */

final class PersistenceManager: PersistenceManagerProtocol {
    enum Key {
        static let favourites = "Favourites"
    }
    
    func retrieveFavourites() -> Result<[Follower], PersistenceError> {
        guard let favouritesData = UserDefaults.standard.object(forKey: Key.favourites) as? Data else {
            return .success([])
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            return .success(favourites)
        } catch {
            return .failure(.unableToFavourites)
        }
    }
    
    func saveFavourites(favourites: [Follower]) -> PersistenceError? {
        do {
            let encoder = JSONEncoder()
            let favouritesData = try encoder.encode(favourites)
            UserDefaults.standard.setValue(favouritesData, forKey: Key.favourites)
            return nil
        } catch {
            return .unableToFavourites
        }
    }
    
    func updateFavourites(actionType: PersistenceManagerAction, favourite: Follower) -> PersistenceError? {
        let retrieveFavourites = self.retrieveFavourites()
        
        switch retrieveFavourites {
        case .success(var existingFavourites):
            switch actionType {
            case .add:
                guard !existingFavourites.contains(favourite) else {
                    return .alreadyAddedToFavourites
                }
                
                existingFavourites.append(favourite)
                
            case .remove:
                existingFavourites.removeAll{ $0.login == favourite.login }
            }
            
            return saveFavourites(favourites: existingFavourites)
        case .failure(let error):
            return error
        }
    }
}

protocol PersistenceManagerProtocol {
    func updateFavourites(actionType: PersistenceManagerAction, favourite: Follower) -> PersistenceError?
    func retrieveFavourites() -> Result<[Follower], PersistenceError>
}
