//
//  RegistrationViewModel.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 08.11.2023.
//
import Foundation

final class RegistrationViewModel {
    
    @Published var userName = String()
    @Published var password = String()
    @Published var isLoading = false
    @Published var loginError: String? = nil
    @Published var isLoggedIn = false
    @Published var loggedInUser: UserProfile?
    @Published var authInUser: AuthResponse?
    
    private let provider = NetworkSwagger()
    
    // Метод для запроса кода аутентификации
    func requestCode(phoneNumber: String) async {
        isLoading = true
        do {
            let response = try await provider.postRequestForCode(phoneNumber: phoneNumber)
            DispatchQueue.main.async { [weak self] in
                print("Успешный результат запроса \(response)")
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
    
    // Метод для аутентификации пользователя с кодом
    func authenticateWithCode(phoneNumber: String, code: String) async {
        isLoading = true
        do {
            let authResponse = try await provider.authenticateUser(phoneNumber: phoneNumber, code: code)
            DispatchQueue.main.async { [weak self] in
                // Обработка результата аутентификации
                // Если аутентификация прошла успешно, то сохраняем полученный токен в authInUser
                self?.isLoggedIn = true
                self?.authInUser = authResponse
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
