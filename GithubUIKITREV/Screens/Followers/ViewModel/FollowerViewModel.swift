//
//  FollowerCellViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation
protocol FollowerViewModelProtocol: AnyObject {
    var follower: Follower { get }
    
    var delegate: FollowerCellViewModelDelegate? { get set}
    
    func downloadImage()
}

final class FollowerViewModel: FollowerViewModelProtocol {
    let follower: Follower
    
    let imageLoader: ImageLoaderProtocol
    
    weak var delegate: FollowerCellViewModelDelegate?
    
    init(imageLoader: ImageLoaderProtocol, follower: Follower) {
        self.follower = follower
        self.imageLoader = imageLoader
    }
    
    func downloadImage() {
        imageLoader.loadImage(for: follower.avatarUrl) { [weak self] imageData in
            guard let self, let imageData else { return }
            self.delegate?.didUpdateImageData(imageData, for: self.follower.login)
        }
    }
    
}

extension FollowerViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(follower.login)
    }
    
    static func == (lhs: FollowerViewModel, rhs: FollowerViewModel) -> Bool {
        return lhs.follower.login == rhs.follower.login
    }
}

protocol FollowerCellViewModelDelegate: AnyObject {
    func didUpdateImageData(_ imageData: Data, for identifier: String)
}
