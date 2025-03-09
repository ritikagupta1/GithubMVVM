//
//  EndPoint.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation

protocol EndPoint {
    var path: String {get}
    var queryItems: [URLQueryItem] {get}
}

extension EndPoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

struct FollowerRequest: EndPoint {
    let userName: String
    let page: Int
    
    var path: String {
        "/users/\(userName)/followers"
    }
    
    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "per_page" , value: "100"),
         URLQueryItem(name: "page", value: "\(page)")]
    }
}

struct UserRequest: EndPoint {
    let userName: String
    
    var path: String {
        "/users/\(userName)"
    }
    
    var queryItems: [URLQueryItem] { [] }
}
