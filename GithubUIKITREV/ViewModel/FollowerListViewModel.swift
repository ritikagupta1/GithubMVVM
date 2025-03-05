//
//  FollowerListViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation
class FollowerListViewModel {
    let userName: String
    
    var followers: ObservableObject<[Follower]> = ObservableObject([])
    let networkManager: NetworkService
    var page: Int = 1
    
    
    init(userName: String, networkManager: NetworkService = NetworkManager.shared) {
        self.userName = userName
        self.networkManager = networkManager
    }
    
    
    func getFollowers() {
        let endPoint = EndPoint.getFollowers(for: userName, page: page)
        
        networkManager.getData(
            endPoint: endPoint) { [weak self] (result: Result<[Follower],GFError>) in
                guard let self else { return }
                switch result {
                case .success(let followers):
                    self.followers.value = followers
                case .failure(let error):
                    print(error)
                }
            }
    }
}
