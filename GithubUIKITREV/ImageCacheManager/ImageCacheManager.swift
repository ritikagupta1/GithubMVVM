//
//  ImageCacheManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation

//Is this threadsafe.

final class ImageCacheManager: ImageCacheServiceProtocol {
    private let imageCache = NSCache<NSString, NSData>()
    
    static let shared = ImageCacheManager()
    
    private init() {}
    
    func set(imageData: Data, for key: String) {
        imageCache.setObject(imageData as NSData, forKey: NSString(string: key))
    }
    
    func getImageData(for key: String) -> Data? {
        return imageCache.object(forKey: NSString(string: key)) as Data?
    }
}

protocol ImageCacheServiceProtocol {
    func set(imageData: Data, for key: String)
    func getImageData(for key: String) -> Data?
}
