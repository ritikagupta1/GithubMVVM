//
//  ImageCacheManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

final class ImageCacheManager {
    private init() {}
    
    static let shared = ImageCacheManager()
    
    let imageCache = NSCache<NSString, NSData>()
    
    func set(imageData: Data,for key: String) {
        self.imageCache.setObject(NSData(data: imageData), forKey: NSString(string: key))
    }
    
    func getImageData(for key: String) -> Data? {
        guard let imageData = self.imageCache.object(forKey: NSString(string: key)) else {
            return nil
        }
        
        return Data(imageData)
    }
}
