//
//  NetworkManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation

/*
 - Coupled with ImageCacheManager
 - NetworkManager should be responsible for network activity only.
 - Separate class for networkManager
 - Separate class for ImageDownload.
 */

final class NetworkManager: NetworkServiceProtocol {
    func getData<T: Codable>(endPoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endPoint.url else {
            completion(.failure(.invalidUserName))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        if let token = Bundle.main.infoDictionary?["ACCESS_TOKEN"] as? String {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        fetchData(request: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    
                    completion(.success(result))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let imageUrl = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: imageUrl)
        
        fetchData(request: request) { result in
            switch result {
            case .success(let imageData):
                completion(imageData)
            case .failure:
                completion(nil)
            }
        }
    }
    
    
    private func fetchData(request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let request = request else {
            completion(.failure(.invalidUserName))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.unableToCompleteRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}


protocol NetworkServiceProtocol {
    func getData<T: Codable>(endPoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void)
    func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void)
}
