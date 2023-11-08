//
//  SwaggerHomeCoordinator.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 08.11.2023.
//

import UIKit

final class SwaggerHomeCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start<USER: Codable>(user: USER? = nil) {
        let viewModel = HomeSwaggerViewModel()
        let homeVC = HomeSwaggerViewController(viewModel: viewModel)
        if let user = user as? UserProfile {
            homeVC.title = "Добро пожаловать \(user.first_name)"
        } else {
            homeVC.title = nil
        }
        navigationController.pushViewController(homeVC, animated: true)
    }
}
