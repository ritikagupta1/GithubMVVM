//
//  FollowerCellViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation
protocol FollowerCellViewModelProtocol {
    var follower: Follower { get }
    
    var delegate: FollowerCellViewModelDelegate? { get set}
    
    func downloadImage()
}

class FollowerCellViewModel: FollowerCellViewModelProtocol {
    let follower: Follower
    let networkManager: NetworkServiceProtocol
    
    var delegate: FollowerCellViewModelDelegate?
    
    init(networkManager: NetworkServiceProtocol, follower: Follower) {
        self.follower = follower
        self.networkManager = networkManager
    }
    
    func downloadImage() {
        networkManager.downloadImage(from: follower.avatarUrl) { [weak self] imageData in
            guard let self, let imageData else { return }
            self.delegate?.didUpdateImageData(imageData)
        }
    }
}

protocol FollowerCellViewModelDelegate: AnyObject {
    func didUpdateImageData(_ imageData: Data)
}
