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
    var imageLoader: ImageLoaderProtocol { get }
    
    func getFollowers()
    func addToFavourites()
    func canFetchMoreFollowers() -> Bool
    func resetSearch()
    func filterFollowers(with query: String)
    func getSelectedFollower(index: Int) -> String
    func searchForNewFollower(with userName: String)
}

final class FollowerListViewModel: FollowerListViewModelProtocol {
    
    weak var delegate: FollowerListViewModelDelegate?
    
    var userName: String
    
    var followers: [FollowerViewModel] = []
    var filteredFollowers: [FollowerViewModel] = []
    
    private var page: Int = 1
    
    private var isLoadingFollowers: Bool = false {
        didSet {
            delegate?.didChangeLoadingState(isLoading: isLoadingFollowers)
        }
    }
    
    private var hasMoreFollowers: Bool = true
    
    private var isSearching: Bool = false
    private var queryText: String = ""
    
    
    let networkManager: NetworkServiceProtocol
    let persistenceManager: PersistenceManagerProtocol
    let imageLoader: ImageLoaderProtocol
    
    init(userName: String,
         networkManager: NetworkServiceProtocol,
         persistenceManager: PersistenceManagerProtocol,
         imageLoader: ImageLoaderProtocol) {
        self.userName = userName
        self.networkManager = networkManager
        self.persistenceManager = persistenceManager
        self.imageLoader = imageLoader
    }
    
    func getFollowers() {
        let endPoint = FollowerRequest(userName: userName, page: page)
        isLoadingFollowers = true
        networkManager.getData(
            endPoint: endPoint) { [weak self] (result: Result<[Follower],NetworkError>) in
                guard let self else { return }
                defer {
                    self.isLoadingFollowers = false
                }
                switch result {
                case .success(let newFollowers):
                    if newFollowers.count < 100 {
                        self.hasMoreFollowers = false
                    }
                    
                    let newFollowersViewModel = newFollowers.map { FollowerViewModel(imageLoader: self.imageLoader, follower: $0)}
                    self.followers.append(contentsOf:newFollowersViewModel )
                    
                    if isSearching {
                        self.filteredFollowers = self.followers.filter{$0.follower.login.lowercased().contains(self.queryText)}
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
        networkManager.getData(endPoint: UserRequest(userName: userName)) { [weak self] (result: Result<User,NetworkError>) in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
                if let error = self.persistenceManager.updateFavourites(actionType: .add, favourite: follower) {
                    self.delegate?.didFinishAddingToFavourites(.failure(errorMessage: error.rawValue))
                } else {
                    self.delegate?.didFinishAddingToFavourites(.success)
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
        filteredFollowers = self.followers.filter{$0.follower.login.lowercased().contains(self.queryText)}
        self.delegate?.didUpdateFollowers(filteredFollowers, isSearchActive: true)
    }
    
    func getSelectedFollower(index: Int) -> String {
        isSearching ? filteredFollowers[index].follower.login : followers[index].follower.login
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
    func didChangeLoadingState(isLoading: Bool)
    func didUpdateFollowers(_ followers: [FollowerViewModel], isSearchActive: Bool)
    func didFailToFetchFollowers(_ message: String)
    func didFinishAddingToFavourites(_ result: AddFavouriteResult)
}
