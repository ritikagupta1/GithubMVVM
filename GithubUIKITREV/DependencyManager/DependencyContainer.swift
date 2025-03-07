//
//  DependencyContainer.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 07/03/25.
//

import Foundation

protocol DependencyProvider {
    var networkService: NetworkServiceProtocol { get }
    var imageCacheService: ImageCacheServiceProtocol { get }
    var persistenceService: PersistenceManagerProtocol { get }
}


class AppDependencyProvider: DependencyProvider {
    lazy var imageCacheService: ImageCacheServiceProtocol = {
        return ImageCacheManager()
    }()
    
    lazy var networkService: NetworkServiceProtocol = {
        return NetworkManager(imageCacheManager: imageCacheService)
    }()
    
    lazy var persistenceService: PersistenceManagerProtocol = {
        return PersistenceManager()
    }()
}
