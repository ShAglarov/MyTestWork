//
//  UserProfile.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 06.11.2023.
//

struct UserProfile: Codable {
    let nickname: String
    let first_name: String
    let last_name: String
    let patronymic: String?
    let birthday: Int?
    let email: String
    let gender: String?
    let gender_label: String?
    let country: String
    let country_label: String
    let city_id: Int?
    let city: String?
    let phone: String
    let avatar: String?
    let avatar_url: String?
    let is_doctor: Bool
    let is_confirmed_doctor: Bool
}
