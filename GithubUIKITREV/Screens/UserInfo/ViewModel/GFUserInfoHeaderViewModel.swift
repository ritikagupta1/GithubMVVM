//
//  GFUserInfoHeaderViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import Foundation
protocol GFUserInfoHeaderViewModelProtocol {
    var delegate: GFUserInfoHeaderViewModelDelegate? { get set }
    var login: String { get }
    var userName: String { get }
    var userLocation: String { get }
    var userBio: String { get }
    func downloadImage()
}

final class GFUserInfoHeaderViewModel: GFUserInfoHeaderViewModelProtocol {
    let imageLoader: ImageLoaderProtocol
    private var user: User
    
    weak var delegate: GFUserInfoHeaderViewModelDelegate?
    
    init(imageLoader: ImageLoaderProtocol, user: User) {
        self.imageLoader = imageLoader
        self.user = user
    }
    
    var login: String {
        user.login
    }
    
    var userName: String {
        user.name ?? ""
    }
    
    var userLocation: String {
        user.location ?? "No Location"
    }
    
    var userBio: String {
        user.bio?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Bio Available"
    }
    
    func downloadImage() {
        imageLoader.loadImage(for: user.avatarUrl) { [weak self] imageData in
            guard let self, let imageData else { return }
            self.delegate?.didUpdateImageData(imageData)
        }
    }
}

protocol GFUserInfoHeaderViewModelDelegate: AnyObject {
    func didUpdateImageData(_ imageData: Data)
}
