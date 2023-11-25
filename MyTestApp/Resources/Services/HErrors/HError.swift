//
//  HError.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 06.11.2023.
//

enum HError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case serverError(code: Int, message: String)
}

enum NetworkError: Error {
    case notFound
    case dataReadingError
    case invalidURL
    case invalidResponse
    case otherError(String)
}
