//
//  NetworkManager.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 02.11.2023.
//

import Foundation

final class NetworkManager {
    
    //https://newsapi.org/v2/everything?q=tesla&from=2023-11-01&softBy=publishedAt&apiKey=2eb9eae4ed484f9b8d6b87fa8184f987
    
    func getNews(value: String, limit: String, completion: @escaping (Result<[OneNews], Error>) -> Void) {
        // 1 - url
        
        var urlComponent = URLComponents()
        
        urlComponent.scheme = "https"
        urlComponent.host = "newsapi.org"
        urlComponent.path = "/v2/everything"
        
        urlComponent.queryItems = [
            URLQueryItem(name: "q", value: value),
            URLQueryItem(name: "pageSize", value: limit),
            URLQueryItem(name: "apiKey", value: "2eb9eae4ed484f9b8d6b87fa8184f987")
        ]
        
        // 2 - запросы
        
        guard let url = urlComponent.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let query = URLRequest(url: url)
        
        // 3 - выполнить запрос
        
        URLSession.shared.dataTask(with: query, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.otherError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.dataReadingError))
                return
            }
            
            guard let result = try? JSONDecoder().decode(Response.self, from: responseData) else {
                completion(.failure(NetworkError.dataReadingError))
                return
            }
            
            completion(.success(result.articles))
            
        }).resume()
    }
}
