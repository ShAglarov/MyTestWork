//
//  NetworkSwagger.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 06.11.2023.
//

import Foundation
import SwiftUI

// Модель ответа аутентификации
struct AuthResponse: Codable {
    let refresh: String
    let access: String
}

final class NetworkSwagger {
    
    private let getCodeURL = "https://dev-hospital.doct24.com/api/v1/auth/login/get/code/"
    private let getTokenURL = "https://dev-hospital.doct24.com/api/v1/auth/login/get/token/"
    private let getProfileURL = "https://dev-hospital.doct24.com/api/v1/auth/profile/"
    private let decoder = JSONDecoder()
    
    // Функция для вызова API аутентификации
    func authenticateUser(phoneNumber: String, code: String) async throws -> AuthResponse {
        let requestBody: [String: Any] = [
            "phone_number": phoneNumber,
            "code": code
        ]
        return try await postRequestGetToken(requestBody: requestBody, responseModel: AuthResponse.self)
    }
    
    func postRequestForCode(phoneNumber: String) async throws -> [String: Any] {
        guard let url = createURL(from: getCodeURL) else { throw HError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = [
            "phone_number": phoneNumber
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return jsonResult
            } else {
                throw HError.invalidResponse
            }
        default:
            let errorData = String(data: data, encoding: .utf8) ?? "No error information"
            throw HError.serverError(code: httpResponse.statusCode, message: errorData)
        }
    }
    
    func getUserProfile(token: String) async throws -> UserProfile {
        return try await postRequest(responseModel: UserProfile.self, token: token)
    }
    
    private func postRequestGetToken<T: Codable>(requestBody: [String: Any], responseModel: T.Type) async throws -> T {
        guard let url = createURL(from: getTokenURL) else {
            throw HError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw HError.invalidData
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try decoder.decode(responseModel, from: data)
        default:
            let errorData = String(data: data, encoding: .utf8) ?? "No error information"
            throw HError.serverError(code: httpResponse.statusCode, message: errorData)
        }
    }
    
    private func buildURLComponents(from baseURL: String) -> URLComponents? {
        guard let base = URL(string: baseURL), let baseScheme = base.scheme, let baseHost = base.host else {
            print("Invalid base URL")
            return nil
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = baseScheme
        urlComponents.host = baseHost
        
        // Определяем, какой части пути следует избежать. Это должен быть общий базовый URL до `/api/`.
        let basePathToAvoid = "\(baseScheme)://\(baseHost)"
        // Убеждаемся, что у нас есть путь, начинающийся с '/api/'.
        if let range = baseURL.range(of: basePathToAvoid) {
            let path = baseURL[range.upperBound...] // Получаем подстроку после основного домена.
            urlComponents.path = String(path).hasPrefix("/") ? String(path) : "/\(path)"
        } else {
            print("Base URL does not contain the path starting with '/api/'")
            return nil
        }
        
        return urlComponents
    }
    
    private func createURL(from baseURL: String) -> URL? {
        let urlComponents = buildURLComponents(from: baseURL)
        return urlComponents?.url
    }
    
    private func postRequest<T: Codable>(responseModel: T.Type, token: String) async throws -> T {
        guard let url = createURL(from: getProfileURL) else {
            throw HError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try decoder.decode(responseModel, from: data)
        default:
            let errorData = String(data: data, encoding: .utf8) ?? "No error information"
            throw HError.serverError(code: httpResponse.statusCode, message: errorData)
        }
    }
}
