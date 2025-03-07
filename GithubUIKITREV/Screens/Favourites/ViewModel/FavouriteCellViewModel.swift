//
//  FavouriteCellViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 07/03/25.
//

import Foundation
protocol FavouritesCellViewModelProtocol {
    var favourite: Follower { get }
    var delegate: FavouritesCellViewModelDelegate? { get set}
    func downloadImage()
}

class FavouriteCellViewModel: FavouritesCellViewModelProtocol {
    let networkManager: NetworkServiceProtocol
    let favourite: Follower
    
    weak var delegate: FavouritesCellViewModelDelegate?
    
    
    init(networkManager: NetworkServiceProtocol, favourite: Follower) {
        self.favourite = favourite
        self.networkManager = networkManager
    }
    
    func downloadImage() {
        networkManager.downloadImage(from: favourite.avatarUrl) { [weak self] imageData in
            guard let self, let imageData else { return }
            self.delegate?.didUpdateImageData(imageData)
        }
    }
}

protocol FavouritesCellViewModelDelegate: AnyObject {
    func didUpdateImageData(_ imageData: Data)
}
