//
//  NetworkManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation

final class NetworkManager: NetworkService {
    private init() {}
    
    static let shared = NetworkManager()
    let imageCacheManager = ImageCacheManager.shared
   
    
    func getData<T: Codable>(endPoint: EndPoint, completion: @escaping (Result<T, GFError>) -> Void) {
        guard let url = endPoint.url else {
            completion(.failure(.invalidUserName))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let _ = error {
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
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data else {
                completion(nil)
                return
            }
            
            self.imageCacheManager.set(imageData: data, for: urlString)
            completion(data)
        }
        
        task.resume()
    }
}


protocol NetworkService {
    func getData<T: Codable>(endPoint: EndPoint, completion: @escaping (Result<T, GFError>) -> Void)
    
    func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void)
}
