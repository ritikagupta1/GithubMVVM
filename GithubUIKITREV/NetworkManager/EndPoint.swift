//
//  EndPoint.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation

struct EndPoint {
    let path: String
    let queryItems: [URLQueryItem]
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

extension EndPoint {
    static func getFollowers(for userName: String, page: Int) -> EndPoint {
        EndPoint(
            path: "/users/\(userName)/followers",
            queryItems: [URLQueryItem(name: "per_page" , value: "100"),
                         URLQueryItem(name: "page", value: "\(page)")])
    }
}
