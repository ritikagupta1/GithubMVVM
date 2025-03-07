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

final class PersistenceManager: PersistenceManagerProtocol {
    enum Key {
        static let favourites = "Favourites"
    }
    
    func retrieveFavourites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favouritesData = UserDefaults.standard.object(forKey: Key.favourites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completion(.success(favourites))
        } catch {
            completion(.failure(.unableToFavourites))
        }
    }
    
    
    func saveFavourites(favourites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let favouritesData = try encoder.encode(favourites)
            UserDefaults.standard.setValue(favouritesData, forKey: Key.favourites)
            return nil
        } catch {
            return .unableToFavourites
        }
    }
    
    
    func updateFavourites(actionType: PersistenceManagerAction, favourite: Follower, completion: @escaping (GFError?) -> Void) {
        self.retrieveFavourites { result in
            switch result {
            case .success(var favourites):
                switch actionType {
                case .add:
                    guard !favourites.contains(favourite) else {
                        completion(.alreadyAddedToFavourites)
                        return
                    }
                    
                    favourites.append(favourite)
                
                case .remove:
                    favourites.removeAll{ $0.login == favourite.login }
                }
                
               completion(self.saveFavourites(favourites: favourites))
            case .failure(let error):
                completion(error)
            }
        }
    }
}

protocol PersistenceManagerProtocol {
    func updateFavourites(actionType: PersistenceManagerAction, favourite: Follower, completion: @escaping (GFError?) -> Void)
    func retrieveFavourites(completion: @escaping (Result<[Follower], GFError>) -> Void)
}
