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

final class GFUserInfoViewModel: GFUserInfoViewModelProtocol {
    let userName: String
    let networkManager: NetworkServiceProtocol
    
    weak var delegate: GFUserInfoViewModelDelegate?
    
    private var isLoadingUserInfo: Bool = false {
        didSet {
            delegate?.didChangeLoadingState(isLoading: isLoadingUserInfo)
        }
    }
    
    init(userName: String, networkManager: NetworkServiceProtocol) {
        self.userName = userName
        self.networkManager = networkManager
    }
    
    
    func getUserInfo() {
        isLoadingUserInfo = true
        networkManager.getData(endPoint: UserRequest(userName: userName)) { [weak self] (result: Result<User,NetworkError>) in
            guard let self = self else {
                return
            }
            defer {
                self.isLoadingUserInfo = false
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
    func didChangeLoadingState(isLoading: Bool)
    func didReceiveUserDetails(_ user: User)
    func didReceiveError(_ errorMessage: String)
}
