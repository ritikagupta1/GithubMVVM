//
//  ImageLoader.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 10/03/25.
//

import Foundation

final class ImageLoader: ImageLoaderProtocol {
    let networkManager: NetworkServiceProtocol
    let imageCacheManager: ImageCacheServiceProtocol
    
    init(networkManager: NetworkServiceProtocol = NetworkManager(),
        imageCacheManager: ImageCacheServiceProtocol = ImageCacheManager.shared) {
        self.networkManager = networkManager
        self.imageCacheManager = imageCacheManager
    }
    
    func loadImage(for urlString: String, completion: @escaping (Data?) -> Void) {
        if let imageData = imageCacheManager.getImageData(for: urlString) {
            completion(imageData)
            return
        }
        
       networkManager.downloadImage(from: urlString) { imageData in
            guard let imageData = imageData else {
                completion(nil)
                return
            }
            
            self.imageCacheManager.set(imageData: imageData, for: urlString)
            completion(imageData)
        }
    }
}

protocol ImageLoaderProtocol {
    func loadImage(for urlString: String, completion: @escaping (Data?) -> Void)
}
