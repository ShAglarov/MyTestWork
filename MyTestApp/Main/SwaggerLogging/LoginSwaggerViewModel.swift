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
    func perform(from token: String) async {
        isLoading = true
        do {
            // Здесь должен быть токен, который вы получили после аутентификации
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
    // Добавляем метод для аутентификации пользователя
    func perform2(from token: String) async {
        let userData = UserProfile(
            username: "freeMan",
            first_name: "Shamil",
            last_name: "Aglarov",
            patronymic: "Patronymic",
            birthday: 123456789, // Unix timestamp
            email: "user@example.com",
            gender: "male",
            gender_label: "Male",
            country: "RU",
            country_label: "Russia",
            city_id: 1,
            city: "Moscow",
            phone: "+79882088886",
            avatar: "",
            avatar_url: "https://example.com/avatar.jpg",
            is_doctor: false,
            is_confirmed_doctor: false
        )
        isLoading = true
        do {
            // Здесь должен быть токен, который вы получили после аутентификации
            let profile = try await provider.postUserProfile(userProfile: userData, token: token)
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
