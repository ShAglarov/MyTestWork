//
//  LoginCoordinator.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import UIKit
import Combine

final class LoginCoordinator: Coordinator {
    
    var currentUser: User?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(user: User?) {
        let viewModel = LoginViewModel()
        let vc = LoginViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
        
        // Обработка пользователя после успешного входа в систему
        viewModel.$loggedInUser.sink { [weak self] (user: User?) in
            if let user = user {
                self?.currentUser = user
                self?.didFinishLogin()
            }
        }.store(in: &cancellables) // Храним подписку в cancellables координатора
    }
    
    func didFinishLogin() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start(user: currentUser)
        resetState()
    }
    
    // Метод для сброса состояния координатора
    func resetState() {
        currentUser = nil
    }
}
