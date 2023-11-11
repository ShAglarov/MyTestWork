//
//  Coordinator.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start<USER: Codable>(user: USER?)
}
