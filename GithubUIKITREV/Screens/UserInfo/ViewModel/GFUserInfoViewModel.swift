//
//  GFUserInfoViewModel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import Foundation
protocol GFUserInfoViewModelProtocol {
    var userName: String {get}
    var networkManager: NetworkServiceProtocol { get }
    
    var delegate: GFUserInfoViewModelDelegate? { get set }
    
    func getUserInfo()
}

class GFUserInfoViewModel: GFUserInfoViewModelProtocol {
    let userName: String
    let networkManager: NetworkServiceProtocol
    
    weak var delegate: GFUserInfoViewModelDelegate?
    
    init(userName: String, networkManager: NetworkServiceProtocol) {
        self.userName = userName
        self.networkManager = networkManager
    }
    
    
    func getUserInfo() {
        networkManager.getData(endPoint: EndPoint.user(for: userName)) { [weak self] (result: Result<User,GFError>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let user):
                delegate?.didReceiveUserDetails(user)
                
            case .failure(let error):
                delegate?.didReceiveError(error.rawValue)
            }
        }
    }
}

protocol GFUserInfoViewModelDelegate: AnyObject {
    func didReceiveUserDetails(_ user: User)
    func didReceiveError(_ errorMessage: String)
}
