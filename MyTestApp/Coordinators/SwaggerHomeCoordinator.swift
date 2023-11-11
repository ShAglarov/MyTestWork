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
            homeVC.lastNameLabel.text = "Фамилия: \(user.last_name)"
            homeVC.patronymicLabel.text = "Отчество: \(user.patronymic ?? "")"
            homeVC.birthDay.text = "Дата рождения: \(user.birthday ?? 1)"
            homeVC.emailLabel.text = "Email: \(user.email)"
            homeVC.genderLabel.text = "Пол: \(user.gender ?? "")"
            homeVC.countryLabel.text = "Страна: \(user.country)"
            homeVC.countryLabelTwo.text = "Страна: \(user.country_label)"
            homeVC.cityIDLabel.text = "Город : \(user.city_id ?? 1)"
            homeVC.cityLabel.text = "Город: \(user.city ?? "")"
            homeVC.phoneLabel.text = "Номер телефона : \(user.phone)"
            homeVC.avatarLabel.text = "Аватар: \(user.avatar ?? "")"
            homeVC.avatarURLLabel.text = "АватарURL: \(user.avatar_url ?? "")"
            homeVC.isDoctorLabel.text = "Лечащий врач: \(user.is_doctor)"
            homeVC.isDoctorSwitch.isOn = user.is_doctor
            homeVC.isConfirmedDoctorLabel.text = "Подтвержденный врач: \(user.is_confirmed_doctor)"
            homeVC.isConfirmedDoctorSwitch.isOn = user.is_confirmed_doctor
        } else {
            homeVC.title = nil
        }
        navigationController.pushViewController(homeVC, animated: true)
    }
}
