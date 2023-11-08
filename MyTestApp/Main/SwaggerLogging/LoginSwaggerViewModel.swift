//
//  LoginSwaggerViewModel.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 06.11.2023.
//

import Foundation

final class LoginSwaggerViewModel {
    
    @Published var userName = String()
    @Published var password = String()
    @Published var isLoading = false
    @Published var loginError: String? = nil
    @Published var isLoggedIn = false
    @Published var loggedInUser: UserProfile?
    
    private let provider = NetworkSwagger()
    
    // Добавляем метод для аутентификации пользователя
    func performLogin() async {
        isLoading = true
        do {
            // Здесь должен быть токен, который вы получили после аутентификации
            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjk5NDA2MTAzLCJpYXQiOjE2OTkzOTczNzIsImp0aSI6IjFiYjZlN2FmYjNkNTQwZjhhOGExMjFjZDQxZjMzNzI4IiwidXNlcl9pZCI6IjEyYjkwZTU3LTEyZTgtNGRjYy05ODNhLTVkMDNhOWI3YzlkNiJ9.UK_FmAHbX5iOWp8WSGZQTTPxrlJy6jKy1YP7BN29vLg"
            let profile = try await provider.getUserProfile(token: token)
            DispatchQueue.main.async { [weak self] in
                self?.loggedInUser = profile
                self?.isLoggedIn = true
                self?.loginError = nil
                self?.isLoading = false
            }
        } catch let error as HError {
            DispatchQueue.main.async { [weak self] in
                self?.loginError = "Ошибка: \(error.localizedDescription)"
                self?.isLoading = false
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.loginError = "Неожиданная ошибка: \(error.localizedDescription)"
                self?.isLoading = false
            }
        }
    }
}
