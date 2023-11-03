//
//  SceneDelegate.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: NewsCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
           
           let navController = UINavigationController()
           coordinator = NewsCoordinator(navigationController: navController)
           coordinator?.start(user: nil)
           
           window = UIWindow(windowScene: scene)
           window?.rootViewController = navController
           window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    func sceneDidBecomeActive(_ scene: UIScene) {

    }
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

