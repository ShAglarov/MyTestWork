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

    func start(user: User?) {
        let viewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: viewModel)
        homeVC.title = user?.name ?? "nil"
        navigationController.pushViewController(homeVC, animated: true)
    }
}
