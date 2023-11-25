//
//  NetworkManager.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 02.11.2023.
//

import Foundation

final class NetworkManager {
    
    private let baseURL = "https://newsapi.org/v2/everything?q=tesla&from=2023-11-01&softBy=publishedAt&apiKey=2eb9eae4ed484f9b8d6b87fa8184f987"
    private let decoder = JSONDecoder()
    
    private func getSchemeHostPath(baseURL: String) throws -> (scheme: String,
                                                               host: String,
                                                               path: String,
                                                               query: String,
                                                               apiKey: String
    ) {
        if let url = URL(string: baseURL),
           let scheme = url.scheme,
           let host = url.host,
            let rangeQuery = baseURL.range(of: "q="),
            let rangeApiKey = baseURL.range(of: "apiKey="
            )
        {
            let path = url.path
            let afterQ = baseURL[rangeQuery.upperBound...]
            let endIndex = afterQ.firstIndex(of: "&") ?? afterQ.endIndex
            let query = String(afterQ[..<endIndex])
            let apiKey = String(baseURL[rangeApiKey.upperBound...])
            return (scheme, host, path, query, apiKey)
        } else {
            throw HError.invalidURL
        }
    }
    
    private func getURLComponents(searchQuery: String) throws -> URLComponents {
        let components = try getSchemeHostPath(baseURL: baseURL)
        
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.scheme = components.scheme
        urlComponents.host = components.host
        urlComponents.path = components.path
        
        let query = components.query
        let apiKey = components.apiKey
        
        if !query.isEmpty || !apiKey.isEmpty {
            var queryItems = [URLQueryItem]()
            
            queryItems.append(URLQueryItem(name: "q", value: searchQuery))
            queryItems.append(URLQueryItem(name: "from", value: "2023-11-01"))
            queryItems.append(URLQueryItem(name: "sortBy", value: "publishedAt"))
            queryItems.append(URLQueryItem(name: "apiKey", value: apiKey))
            
            urlComponents.queryItems = queryItems
            
            return urlComponents
        }
        throw HError.invalidURL
    }
    
    private func requestGetNews<T: Codable>(searchQuery: String, responceModel: T.Type) async throws -> T {
        guard let url = try getURLComponents(searchQuery: searchQuery).url else {
            throw HError.invalidURL
        }
        
        let request = try URLRequest(url: url, method: .get)
        
        let (data, responce) = try await URLSession.shared.data(for: request)
        
        guard let httpResponce = responce as? HTTPURLResponse else {
            throw HError.invalidResponse
        }
        
        switch httpResponce.statusCode {
        case 200..<300:
            return try decoder.decode(responceModel, from: data)
        default:
            let errorData = String(data: data, encoding: .utf8) ?? ""
            throw HError.serverError(code: httpResponce.statusCode, message: errorData)
        }
    }
    
    func getNews(searchQuery: String) async throws -> Response {
        try await requestGetNews(searchQuery: searchQuery, responceModel: Response.self)
    }
}
