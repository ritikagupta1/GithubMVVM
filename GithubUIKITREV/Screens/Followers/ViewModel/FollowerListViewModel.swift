//
//  FollowerListViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation
protocol FollowerListViewModelProtocol {
    var delegate: FollowerListViewModelDelegate? { get set }
    var userName: String { get }
    
    var networkManager: NetworkServiceProtocol { get }
    var persistenceManager: PersistenceManagerProtocol { get }
    
    func getFollowers()
    func addToFavourites()
    func canFetchMoreFollowers() -> Bool
    func resetSearch()
    func filterFollowers(with query: String)
    
    func getSelectedFollower(index: Int) -> Follower
    func searchForNewFollower(with userName: String)
}

class FollowerListViewModel: FollowerListViewModelProtocol {
    
    weak var delegate: FollowerListViewModelDelegate?
    
    var userName: String
    
    private var followers: [Follower] = []
    private var filteredFollowers: [Follower] = []
    private var page: Int = 1
    
    private var isLoadingFollowers: Bool = false
    private var hasMoreFollowers: Bool = true
    
    private var isSearching: Bool = false
    private var queryText: String = ""
    
    let networkManager: NetworkServiceProtocol
    let persistenceManager: PersistenceManagerProtocol
    
    
    init(userName: String,
         networkManager: NetworkServiceProtocol,
         persistenceManager: PersistenceManagerProtocol) {
        self.userName = userName
        self.networkManager = networkManager
        self.persistenceManager = persistenceManager
    }
    
    
    func getFollowers() {
        let endPoint = EndPoint.getFollowers(for: userName, page: page)
        isLoadingFollowers = true
        networkManager.getData(
            endPoint: endPoint) { [weak self] (result: Result<[Follower],GFError>) in
                guard let self else { return }
                defer {
                    self.isLoadingFollowers = false
                }
                switch result {
                case .success(let newFollowers):
                    if newFollowers.count < 100 {
                        self.hasMoreFollowers = false
                    }
                    self.followers.append(contentsOf: newFollowers)
                    
                    if isSearching {
                        self.filteredFollowers = self.followers.filter{ $0.login.lowercased().contains(self.queryText)}
                        delegate?.didUpdateFollowers(filteredFollowers, isSearchActive: true)
                    } else {
                        delegate?.didUpdateFollowers(self.followers, isSearchActive: false)
                    }
                    
                    self.page += 1
                    
                case .failure(let error):
                    delegate?.didFailToFetchFollowers(error.rawValue)
                }
            }
    }
    
    
    func addToFavourites() {
        networkManager.getData(endPoint: EndPoint.user(for: userName)) { (result: Result<User,GFError>) in
            switch result {
                
            case .success(let user):
                let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
                self.persistenceManager.updateFavourites(actionType: .add, favourite: follower) { [weak self] error in
                    guard let self else { return }
                    guard let error else {
                        self.delegate?.didFinishAddingToFavourites(.success)
                        return
                    }
                    self.delegate?.didFinishAddingToFavourites(.failure(errorMessage: error.rawValue))
                }
            
            case .failure(let error):
                self.delegate?.didFinishAddingToFavourites(.failure(errorMessage: error.rawValue))
            }
        }
    }
    
    
    func canFetchMoreFollowers() -> Bool {
        hasMoreFollowers && !(isLoadingFollowers)
    }
    
    func resetSearch() {
        isSearching = false
        filteredFollowers.removeAll()
        self.delegate?.didUpdateFollowers(self.followers, isSearchActive: false)
    }
    
    func filterFollowers(with query: String) {
        isSearching = true
        queryText = query.lowercased()
        filteredFollowers = self.followers.filter{  $0.login.lowercased().contains(queryText)}
        self.delegate?.didUpdateFollowers(filteredFollowers, isSearchActive: true)
    }
    
    func getSelectedFollower(index: Int) -> Follower {
        isSearching ? filteredFollowers[index] : followers[index]
    }
    
    func searchForNewFollower(with userName: String) {
        self.userName = userName
        self.page = 1
        self.filteredFollowers.removeAll()
        self.followers.removeAll()
        
        self.isSearching = false
        self.hasMoreFollowers = true
        self.isLoadingFollowers = false
        
        self.getFollowers()
    }
}

enum AddFavouriteResult {
    case success
    case failure(errorMessage: String)
}

protocol FollowerListViewModelDelegate: AnyObject {
    func didUpdateFollowers(_ followers: [Follower], isSearchActive: Bool)
    func didFailToFetchFollowers(_ message: String)
    func didFinishAddingToFavourites(_ result: AddFavouriteResult)
}
