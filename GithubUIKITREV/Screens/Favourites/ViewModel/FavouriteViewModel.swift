//
//  FavouriteCellViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 07/03/25.
//

import Foundation
protocol FavouritesCellViewModelProtocol: AnyObject {
    var favourite: Follower { get }
    var delegate: FavouritesCellViewModelDelegate? { get set}
    func downloadImage()
}

final class FavouriteViewModel: FavouritesCellViewModelProtocol {
    let imageLoader: ImageLoaderProtocol
    let favourite: Follower
    
    weak var delegate: FavouritesCellViewModelDelegate?
    
    
    init(imageLoader: ImageLoaderProtocol, favourite: Follower) {
        self.favourite = favourite
        self.imageLoader = imageLoader
    }
    
    func downloadImage() {
        imageLoader.loadImage(for: favourite.avatarUrl) { [weak self] imageData in
            guard let self, let imageData else { return }
            self.delegate?.didUpdateImageData(imageData, for: self.favourite.login)
        }
    }
}

protocol FavouritesCellViewModelDelegate: AnyObject {
    func didUpdateImageData(_ imageData: Data,for identifier: String)
}
