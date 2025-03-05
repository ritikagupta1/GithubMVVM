//
//  FollowerCellViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation
class FollowerCellViewModel {
    let follower: Follower
    let networkManager: NetworkService
    
    var imageData :ObservableObject<Data?> = ObservableObject(nil)
    
    init(networkManager: NetworkService, follower: Follower) {
        self.follower = follower
        self.networkManager = networkManager
    }
    
    func downloadImage() {
        networkManager.downloadImage(from: follower.avatarUrl) { [weak self] imageData in
            guard let self else {return}
            self.imageData.value = imageData
        }
    }
}
