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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start<USER: Codable>(user: USER? = nil) {
        let viewModel = LoginSwaggerViewModel()
        
        let vc = LoginSwaggerViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
        
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
    
    // Метод для сброса состояния координатора
    func resetState() {
        userProfile = nil
    }
}
