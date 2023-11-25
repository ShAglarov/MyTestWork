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
    
    func start<USER>(user: USER? = nil) {
        let viewModel = NewsViewModel()
        let newsVC = NewsViewController(viewModel: viewModel)
        if let user = user as? User {
            newsVC.title = user.name
        } else {
            newsVC.title = ""
        }
        navigationController.pushViewController(newsVC, animated: true)
    }
}
