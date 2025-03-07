//
//  NetworkManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation

final class NetworkManager: NetworkServiceProtocol {
    private let imageCacheManager: ImageCacheServiceProtocol
    
    init(imageCacheManager: ImageCacheServiceProtocol) {
        self.imageCacheManager = imageCacheManager
    }
    
    func getData<T: Codable>(endPoint: EndPoint, completion: @escaping (Result<T, GFError>) -> Void) {
        guard let url = endPoint.url else {
            completion(.failure(.invalidUserName))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        if let token = Bundle.main.infoDictionary?["ACCESS_TOKEN"] as? String {
               urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
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
            
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                
                completion(.success(result))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        if let imageData = imageCacheManager.getImageData(for: urlString) {
            completion(imageData)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil)
                return
            }
            
            self.imageCacheManager.set(imageData: data, for: urlString)
            completion(data)
        }
        
        task.resume()
    }
}


protocol NetworkServiceProtocol {
    func getData<T: Codable>(endPoint: EndPoint, completion: @escaping (Result<T, GFError>) -> Void)
    func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void)
}
