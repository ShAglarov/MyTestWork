//
//  HomeSwaggerViewController.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 08.11.2023.
//

import UIKit
import Combine

final class HomeSwaggerViewController: UIViewController {
    
    private var viewModel = HomeSwaggerViewModel()
    private let appView = AppView()
    
    init(viewModel: HomeSwaggerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var coordinator: SwaggerHomeCoordinator?

    let scrollView = UIScrollView()
    let contentView = UIView()
    var profileUser: UserProfile?
    
    lazy var nickNameLabel: UILabel = {
        let nickName = profileUser?.nickname ?? "-"
        return appView.textLabel(text: "Nick Name: \(nickName)")
    }()
    lazy var firstNameLabel: UILabel = {
        let firstName = profileUser?.first_name ?? "-"
        return appView.textLabel(text: "First Name: \(firstName)")
    }()
    lazy var lastNameLabel: UILabel = {
        let lastName = profileUser?.last_name ?? "-"
        return appView.textLabel(text: "Last Name: \(lastName)")
    }()
     lazy var patronymicLabel: UILabel = {
         let patronymic = profileUser?.patronymic ?? "-"
         return appView.textLabel(text: "Patronymic: \(patronymic)")
    }()
     lazy var birthDay: UILabel = {
         let birthday = profileUser?.birthday ?? 0
         return appView.textLabel(text: "Date of Birth: \(birthday)")
    }()
     lazy var emailLabel: UILabel = {
         let email = profileUser?.email ?? "-"
         return appView.textLabel(text: "Email: \(email)")
    }()
     lazy var genderLabel: UILabel = {
         let gender = profileUser?.gender ?? "-"
         return appView.textLabel(text: "Gender: \(gender)")
    }()

     lazy var countryLabel: UILabel = {
         let country = profileUser?.country ?? "-"
         return appView.textLabel(text: "Country: \(country)")
    }()
     lazy var countryLabelTwo: UILabel = {
         let country = profileUser?.country ?? "-"
         return appView.textLabel(text: "Country Label: \(country)")
    }()
     lazy var cityIDLabel: UILabel = {
         let city = profileUser?.city ?? "-"
         return appView.textLabel(text: "City ID: \(city)")
    }()
     lazy var cityLabel: UILabel = {
         let city = profileUser?.city ?? "-"
         return appView.textLabel(text: "City: \(city)")
    }()
     lazy var phoneLabel: UILabel = {
         let phone = profileUser?.phone ?? "-"
         return appView.textLabel(text: "Phone: \(phone)")
    }()
     lazy var avatarLabel: UILabel = {
         let avatar = profileUser?.avatar ?? "-"
         return appView.textLabel(text: "Avatar: \(avatar)")
    }()
     lazy var avatarURLLabel: UILabel = {
         let avatar = profileUser?.avatar ?? "-"
         return appView.textLabel(text: "Avatar URL: \(avatar)")
    }()
     lazy var isDoctorLabel: UILabel = {
         let isDoctor = profileUser?.is_doctor ?? false
         return appView.textLabel(text: "Is Doctor?: \(isDoctor)")
    }()
     lazy var isDoctorSwitch: UISwitch = {
        var isDoctor = UISwitch()
        return isDoctor
    }()
     lazy var isConfirmedDoctorLabel: UILabel = {
         let isConfirmedDoctor = profileUser?.is_confirmed_doctor ?? false
         return appView.textLabel(text: "Is Confirmed Doctor?: \(isConfirmedDoctor)")
    }()
     lazy var isConfirmedDoctorSwitch: UISwitch = {
        var isConfirmedDoctor = UISwitch()
        return isConfirmedDoctor
    }()
     lazy var birthdayDatePicker: UIDatePicker = {
        var birthday = UIDatePicker()
        return birthday
    }()

    // Запускаем индикатор загрузки в панели навигации
    func showLoading() {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    }
    
    // Скрываем индикатор загрузки и возвращаем кнопки добавления на панель навигации
    func hideLoading() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupScrollView()
        setupUserProfileUI()
        
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
        }
    }
    
    func setupUserProfileUI() {
        var lastView: UIView = contentView
        
        contentView.addSubview(phoneLabel)
        setupConstraintsForView(phoneLabel, below: lastView, isTopView: true)
        lastView = phoneLabel
        
        contentView.addSubview(nickNameLabel)
        setupConstraintsForView(nickNameLabel, below: lastView)
        lastView = nickNameLabel

        contentView.addSubview(firstNameLabel)
        setupConstraintsForView(firstNameLabel, below: lastView)
        lastView = firstNameLabel

        contentView.addSubview(lastNameLabel)
        setupConstraintsForView(lastNameLabel, below: lastView)
        lastView = lastNameLabel

        contentView.addSubview(patronymicLabel)
        setupConstraintsForView(patronymicLabel, below: lastView)
        lastView = patronymicLabel

        contentView.addSubview(birthDay)
        setupConstraintsForView(birthDay, below: lastView)
        lastView = birthDay

        contentView.addSubview(emailLabel)
        setupConstraintsForView(emailLabel, below: lastView)
        lastView = emailLabel

        contentView.addSubview(genderLabel)
        setupConstraintsForView(genderLabel, below: lastView)
        lastView = genderLabel

        contentView.addSubview(genderLabel)
        setupConstraintsForView(genderLabel, below: lastView)
        lastView = genderLabel

        contentView.addSubview(countryLabel)
        setupConstraintsForView(countryLabel, below: lastView)
        lastView = countryLabel

        contentView.addSubview(countryLabelTwo)
        setupConstraintsForView(countryLabelTwo, below: lastView)
        lastView = countryLabelTwo

        contentView.addSubview(cityIDLabel)
        setupConstraintsForView(cityIDLabel, below: lastView)
        lastView = cityIDLabel

        contentView.addSubview(cityLabel)
        setupConstraintsForView(cityLabel, below: lastView)
        lastView = cityLabel

        contentView.addSubview(avatarLabel)
        setupConstraintsForView(avatarLabel, below: lastView)
        lastView = avatarLabel

        contentView.addSubview(avatarURLLabel)
        setupConstraintsForView(avatarURLLabel, below: lastView)
        lastView = avatarURLLabel

        contentView.addSubview(isDoctorLabel)
        setupConstraintsForLabel(isDoctorLabel, beside: lastView)
        lastView = isDoctorLabel

        contentView.addSubview(isDoctorSwitch)
        setupConstraintsForSwitch(isDoctorSwitch, beside: isDoctorLabel)
        lastView = isDoctorSwitch

        contentView.addSubview(isConfirmedDoctorLabel)
        setupConstraintsForLabel(isConfirmedDoctorLabel, beside: lastView)
        lastView = isConfirmedDoctorLabel

        contentView.addSubview(isConfirmedDoctorSwitch)
        setupConstraintsForSwitch(isConfirmedDoctorSwitch, beside: isConfirmedDoctorLabel)
        lastView = isConfirmedDoctorSwitch
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(lastView).offset(20)
        }
    }

    func addLabelAndSetConstraints(Label: UILabel, below lastView: UIView, isTopView: Bool = false) {
        contentView.addSubview(Label)
        setupConstraintsForView(Label, below: lastView, isTopView: isTopView)
    }

    func setupConstraintsForView(_ view: UIView, below lastView: UIView, isTopView: Bool = false) {
        view.snp.makeConstraints { make in
            if isTopView {
                make.top.equalToSuperview().offset(20)
            } else {
                make.top.equalTo(lastView.snp.bottom).offset(10)
            }
            make.left.right.equalToSuperview().inset(20)
            
            if view is UILabel {
                make.height.equalTo(40)
            } else if view is UIDatePicker {
                make.height.equalTo(100)
            } else if view is UIButton {
                make.height.equalTo(50)
            } else if view is UISegmentedControl {
                make.height.equalTo(30)
            } else if view is UISwitch {
                make.height.equalTo(31)
            }
        }
    }

    func setupConstraintsForSwitch(_ switchControl: UISwitch, beside lastLabel: UILabel) {
        switchControl.snp.makeConstraints { make in
            make.centerY.equalTo(lastLabel)
            make.left.equalTo(lastLabel.snp.right).offset(10)
        }
    }
    func setupConstraintsForLabel(_ label: UILabel, beside lastView: UIView) {
        label.snp.makeConstraints { make in
            make.top.equalTo(lastView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
    }
}
