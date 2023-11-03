//
//  NewsCoordinator.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 03.11.2023.
//

import UIKit

final class NewsCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(user: User?) {
        let viewModel = NewsViewModel()
        let newsVC = NewsViewController(viewModel: viewModel)
        newsVC.title = user?.name ?? "nil"
        navigationController.pushViewController(newsVC, animated: true)
    }
}
