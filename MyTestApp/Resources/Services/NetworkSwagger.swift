//
//  NetworkSwagger.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 06.11.2023.
//

import Foundation

final class NetworkSwagger {
    
    private let baseHospitalURL = "https://dev-hospital.doct24.com/api/v1/auth/profile/"
    private let decoder = JSONDecoder()

    func getUserProfile(token: String) async throws -> UserProfile {
        return try await postRequest(responseModel: UserProfile.self, token: token)
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

    private func createFromHospitalURL() -> URL? {
        var urlComponents = buildURLComponents(from: baseHospitalURL)
        return urlComponents?.url
    }

    private func postRequest<T: Codable>(responseModel: T.Type, token: String) async throws -> T {
        guard let url = createFromHospitalURL() else {
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