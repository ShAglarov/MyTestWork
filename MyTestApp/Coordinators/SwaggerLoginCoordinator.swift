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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start<USER: Codable>(user: USER? = nil) {
        let viewModel = LoginSwaggerViewModel()
        
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
        let newsCoordinator = NewsCoordinator(navigationController: navigationController)
        childCoordinators.append(newsCoordinator)
        // Здесь мы передаем полученный userProfile как параметр
        newsCoordinator.start(user: userProfile)
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
