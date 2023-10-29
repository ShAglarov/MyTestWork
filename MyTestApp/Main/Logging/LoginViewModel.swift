//
//  LoginViewModel.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import Foundation
import Combine
import Moya

final class LoginViewModel {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var loginError: String? = nil
    @Published var isLoggedIn: Bool = false
    // Добавляем свойство для авторизованного пользователя
    @Published var loggedInUser: User?
    
    private let provider = MoyaProvider<JSONPlaceholderAPI>()
    private var users = [User]()
    var cancellables: Set<AnyCancellable> = []
    
    func login() {
        isLoading = true
        loginError = nil
        
        provider.request(.users) { [weak self] result in
            self?.isLoading = false
            // Проверяем логин и пароль
            switch result {
            case .success(let response):
                do {
                    self?.users = try JSONDecoder().decode([User].self, from: response.data)
                    if let user = self?.users.first(where: {
                        $0.username == self?.username && $0.id == Int(self?.password ?? "")
                    }) {
                        self?.isLoggedIn = true
                        // авторизованный пользователь
                        self?.loggedInUser = user
                    } else {
                        self?.loginError = "Invalid username or password."
                    }
                } catch {
                    self?.loginError = "Error decoding users: \(error)"
                }
            case .failure(let error):
                self?.loginError = "Error fetching users: \(error)"
            }
        }
    }
}

/*
 login: Bret 
 password: 1
 login: Antonette 
 password: 2
 login: Samantha 
 password: 3
 login: Karianne 
 password: 4
 login: Kamren
 password: 5
 login: Leopoldo_Corkery 
 password: 6
 login: Elwyn.Skiles 
 password: 7
 login: Maxime_Nienow 
 password: 8
 login: Delphine 
 password: 9
 login: Moriah.Stanton
 password: 10
 */
