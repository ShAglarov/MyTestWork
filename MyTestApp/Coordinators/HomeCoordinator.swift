//
//  HomeCoordinator.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start<USER: Codable>(user: USER? = nil) {
        let viewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: viewModel)
        if let user = user as? User {
            homeVC.title = user.name
        } else {
            homeVC.title = nil
        }
        navigationController.pushViewController(homeVC, animated: true)
    }
}
