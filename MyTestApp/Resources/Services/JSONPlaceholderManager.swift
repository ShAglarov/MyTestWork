//
//  JSONPlaceholderManager.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import Moya
import Foundation

enum JSONPlaceholderAPI {
    case posts
    case users
    case photos
}

extension JSONPlaceholderAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .users:
            return "/users"
        case .photos:
            return "/photos"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}


//MARK: - Менеджер для запросов
class JSONPlaceholderManager {
    
    let provider = MoyaProvider<JSONPlaceholderAPI>()
    
    func fetchPosts(completion: @escaping (Result<Posts, Error>) -> Void) {
        provider.request(.posts) { result in
            self.handleResult(result, completion: completion)
        }
    }
    
    func fetchUsers(completion: @escaping (Result<Users, Error>) -> Void) {
        provider.request(.users) { result in
            self.handleResult(result, completion: completion)
        }
    }
    
    func fetchPhotos(completion: @escaping (Result<Photos, Error>) -> Void) {
        provider.request(.photos) { result in
            self.handleResult(result, completion: completion)
        }
    }
    
    private func handleResult<T: Decodable>(_ result: Result<Moya.Response, MoyaError>, completion: (Result<T, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: response.data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
