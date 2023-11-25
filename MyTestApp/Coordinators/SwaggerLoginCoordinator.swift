//
//  SwaggerLoginCoordinator.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 07.11.2023.
//

import UIKit
import Combine

final class SwaggerLoginCoordinator: Coordinator {
    
    var userProfile: UserProfile?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []
    var onTokenReceived: ((String, String) -> Void)?
    
    var sharedNetwork = NetworkSinglton.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start<USER: Codable>(user: USER? = nil) {
        let viewModel = LoginSwaggerViewModel()
        let sharedUserAuth = StorageToken.shared
        
        if let token = sharedUserAuth.load() {
            print("access: \(token.access)\n refresh: \(token.refresh)")
            
            guard let expirationDateInMoscow = sharedUserAuth
                .getExpirationDateInMoscowTime(decodeJWT: sharedUserAuth.exampleJWTDecoder,
                                               token: token.access
                )
            else {
                print("Не удалось извлечь дату истечения срока действия токена.")
                return
            }
            print("ДАТА ОКОНЧАНИЯ ТОКЕНА - \(expirationDateInMoscow)")
            
            let dateInfo = CurrentDateInfo()
            
            Task {
                do {
                    guard let currentDateInfo = try await sharedNetwork.getMoscowTime() else {
                        print("Не удалось получить информацию о текущем времени")
                        return
                    }

                    guard let moscowDate = currentDateInfo.parsedDate() else {
                        print("Не удалось преобразовать строку в дату")
                        return
                    }

                    print("Текущая дата - \(moscowDate)")

                    if moscowDate > expirationDateInMoscow {
                        do {
                            let newToken = try await self.sharedNetwork.getToken(refresh: token.refresh)
                               let refreshToken = newToken["refresh"] as! String
                               let accessToken = newToken["access"] as! String
                            let newAuthResponce = AuthResponse(refresh: refreshToken, access: accessToken)
                            DispatchQueue.main.async { // Обновление UI на главном потоке
                                sharedUserAuth.save(authUser: newAuthResponce)
                                print("Срок действия токена истек, вы получили новый токен, попробуйте войти снова")
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("Ошибка при получении нового токена: \(error.localizedDescription)")
                            }
                        }
                    }
                } catch {
                    print("Ошибка при получении текущего времени: \(error.localizedDescription)")
                }
            }
        }
        
        let loginVC = LoginSwaggerViewController(viewModel: viewModel)
        loginVC.coordinator = self
        
        self.onTokenReceived = { [weak loginVC] access, numberPhone in
            loginVC?.updateWithToken(access)
            loginVC?.usernameTextField.text = numberPhone
        }
        
        navigationController.pushViewController(loginVC, animated: true)
        
        viewModel.$loggedInUser.sink { [weak self] (user: UserProfile?) in
            if let user = user {
                self?.userProfile = user
                self?.didFinishLogin()
            }
        }.store(in: &cancellables)
    }
    
    func didFinishLogin() {
        let homeCoordinator = SwaggerHomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        // Здесь мы передаем полученный userProfile как параметр
        homeCoordinator.start(user: userProfile)
        resetState()
    }
    
    func navigateToRegistration() {
        let registrationCoordinator = RegistrationCoordinator(navigationController: navigationController)
        registrationCoordinator.onSendToken = { [weak self] access, numberPhone in
            self?.onTokenReceived?(access, numberPhone)
        }
        childCoordinators.append(registrationCoordinator)
        registrationCoordinator.start(user: nil as User?)
    }
    
    // Метод для сброса состояния координатора
    func resetState() {
        userProfile = nil
    }
}
