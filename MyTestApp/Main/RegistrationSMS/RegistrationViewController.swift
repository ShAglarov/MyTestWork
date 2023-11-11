//
//  RegistrationViewController.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 08.11.2023.
//

import UIKit
import SnapKit
import Combine

final class RegistrationViewController: UIViewController {

    private var viewModel = RegistrationViewModel()
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var coordinator: RegistrationCoordinator?
    private let provider = NetworkSwagger()
    
    private var cancellables: Set<AnyCancellable> = []
    
    let appView = AppView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var profileUser: UserProfile?

    private lazy var usernameTextField: UITextField = {
        appView.textField(placeholder: "Username")
    }()
    private lazy var firstNameTextField: UITextField = {
        appView.textField(placeholder: "First Name")
    }()
    private lazy var lastNameTextField: UITextField = {
        appView.textField(placeholder: "Last Name")
    }()
    private lazy var patronymicTextField: UITextField = {
        appView.textField(placeholder: "Patronymic")
    }()
    private lazy var birthDay: UITextField = {
        appView.textField(placeholder: "Date of Birth")
    }()
    private lazy var emailTextField: UITextField = {
        appView.textField(placeholder: "Email")
    }()
    private lazy var genderTextField: UITextField = {
        appView.textField(placeholder: "Gender")
    }()
    private lazy var genderLabel: UITextField = {
        appView.textField(placeholder: "Gender Label")
    }()
    private lazy var countryTextField: UITextField = {
        appView.textField(placeholder: "Country")
    }()
    private lazy var countryLabelTextField: UITextField = {
        appView.textField(placeholder: "Country Label")
    }()
    private lazy var cityIDTextField: UITextField = {
        appView.textField(placeholder: "City ID")
    }()
    private lazy var cityTextField: UITextField = {
        appView.textField(placeholder: "City")
    }()
    private lazy var phoneTextField: UITextField = {
        appView.textField(placeholder: "Phone")
    }()
    private lazy var avatar: UITextField = {
        appView.textField(placeholder: "Avatar")
    }()
    private lazy var avatarURL: UITextField = {
        appView.textField(placeholder: "Avatar URL")
    }()
    private lazy var isDoctorLabel: UILabel = {
        appView.textLabel(text: "Is Doctor?")
    }()
    private lazy var isDoctorSwitch: UISwitch = {
        var isDoctor = UISwitch()
        return isDoctor
    }()
    private lazy var isConfirmedDoctorLabel: UILabel = {
        appView.textLabel(text: "Is Confirmed Doctor?")
    }()
    private lazy var isConfirmedDoctorSwitch: UISwitch = {
        var isConfirmedDoctor = UISwitch()
        return isConfirmedDoctor
    }()
    private lazy var birthdayDatePicker: UIDatePicker = {
        var birthday = UIDatePicker()
        return birthday
    }()
    private lazy var loginButton: UIButton = {
        appView.button(title: "Получить токен",
                       titleColor: .white,
                       backgroundColor: .blue,
                       cornerRadius: 5,
                       action: #selector(loginTapped), target: self)
    }()
    private lazy var newTokenTextView: UITextView = {
        appView.textView(isScrollEnabled: false)
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
        
        // Настраиваем привязку к ViewModel
        bindViewModel()
        
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
        
        // Инициализация и настройка полей ввода и других элементов
        //phoneTextField = appView.textField(placeholder: "Phone")
        contentView.addSubview(phoneTextField)
        setupConstraintsForView(phoneTextField, below: lastView, isTopView: true)
        lastView = phoneTextField
        
        //usernameTextField = appView.textField(placeholder: "Username")
        contentView.addSubview(usernameTextField)
        setupConstraintsForView(usernameTextField, below: lastView)
        lastView = usernameTextField

        //firstNameTextField = appView.textField(placeholder: "First Name")
        contentView.addSubview(firstNameTextField)
        setupConstraintsForView(firstNameTextField, below: lastView)
        lastView = firstNameTextField

        //lastNameTextField = appView.textField(placeholder: "Last Name")
        contentView.addSubview(lastNameTextField)
        setupConstraintsForView(lastNameTextField, below: lastView)
        lastView = lastNameTextField

        //patronymicTextField = appView.textField(placeholder: "Patronymic")
        contentView.addSubview(patronymicTextField)
        setupConstraintsForView(patronymicTextField, below: lastView)
        lastView = patronymicTextField
        
        //birthDay = appView.textField(placeholder: "Date of Birth")
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        birthDay.inputView = datePicker

        // Добавление тулбара с кнопкой "Done"
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        toolbar.setItems([doneButton], animated: true)
        birthDay.inputAccessoryView = toolbar

        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)

        contentView.addSubview(birthDay)  // Исправлено на добавление в contentView
        setupConstraintsForView(birthDay, below: lastView)
        lastView = birthDay

        //emailTextField = appView.textField(placeholder: "Email")
        contentView.addSubview(emailTextField)
        setupConstraintsForView(emailTextField, below: lastView)
        lastView = emailTextField

        //genderTextField = appView.textField(placeholder: "Gender")
        contentView.addSubview(genderTextField)
        setupConstraintsForView(genderTextField, below: lastView)
        lastView = genderTextField

        //genderLabel = appView.textField(placeholder: "Gender Label")
        contentView.addSubview(genderLabel)
        setupConstraintsForView(genderLabel, below: lastView)
        lastView = genderLabel

        //countryTextField = appView.textField(placeholder: "Country")
        contentView.addSubview(countryTextField)
        setupConstraintsForView(countryTextField, below: lastView)
        lastView = countryTextField

        //countryLabelTextField = appView.textField(placeholder: "Country Label")
        contentView.addSubview(countryLabelTextField)
        setupConstraintsForView(countryLabelTextField, below: lastView)
        lastView = countryLabelTextField

        //cityIDTextField = appView.textField(placeholder: "City ID")
        contentView.addSubview(cityIDTextField)
        setupConstraintsForView(cityIDTextField, below: lastView)
        lastView = cityIDTextField

        //cityTextField = appView.textField(placeholder: "City")
        contentView.addSubview(cityTextField)
        setupConstraintsForView(cityTextField, below: lastView)
        lastView = cityTextField

        //avatar = appView.textField(placeholder: "Avatar")
        contentView.addSubview(avatar)
        setupConstraintsForView(avatar, below: lastView)
        lastView = avatar

        //avatarURL = appView.textField(placeholder: "Avatar URL")
        contentView.addSubview(avatarURL)
        setupConstraintsForView(avatarURL, below: lastView)
        lastView = avatarURL

        //let isDoctorLabel = UILabel()
        contentView.addSubview(isDoctorLabel)
        setupConstraintsForLabel(isDoctorLabel, beside: lastView)
        lastView = isDoctorLabel

        //isDoctorSwitch = UISwitch()
        contentView.addSubview(isDoctorSwitch)
        setupConstraintsForSwitch(isDoctorSwitch, beside: isDoctorLabel)
        lastView = isDoctorSwitch

        //let isConfirmedDoctorLabel = UILabel()
        //isConfirmedDoctorLabel.text = "Is Confirmed Doctor?"
        contentView.addSubview(isConfirmedDoctorLabel)
        setupConstraintsForLabel(isConfirmedDoctorLabel, beside: lastView)
        lastView = isConfirmedDoctorLabel

        //isConfirmedDoctorSwitch = UISwitch()
        contentView.addSubview(isConfirmedDoctorSwitch)
        setupConstraintsForSwitch(isConfirmedDoctorSwitch, beside: isConfirmedDoctorLabel)
        lastView = isConfirmedDoctorSwitch
        
        contentView.addSubview(loginButton)
        setupConstraintsForView(loginButton, below: lastView)
        lastView = loginButton
        
        //newTokenTextView = appView.textView(isScrollEnabled: false)
        newTokenTextView.isHidden = true
        contentView.addSubview(newTokenTextView)
        setupConstraintsForView(newTokenTextView, below: lastView)
        
        // Задайте дополнительные констрейнты для newTokenTextView
        newTokenTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(40)
            make.height.lessThanOrEqualTo(200)
        }
        lastView = newTokenTextView
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(lastView).offset(20)
        }
    }

    func addTextFieldAndSetConstraints(textField: UITextField, below lastView: UIView, isTopView: Bool = false) {
        contentView.addSubview(textField)
        setupConstraintsForView(textField, below: lastView, isTopView: isTopView)
    }

    func setupConstraintsForView(_ view: UIView, below lastView: UIView, isTopView: Bool = false) {
        view.snp.makeConstraints { make in
            if isTopView {
                make.top.equalToSuperview().offset(20)
            } else {
                make.top.equalTo(lastView.snp.bottom).offset(10)
            }
            make.left.right.equalToSuperview().inset(20)
            
            if view is UITextField {
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

    func createUserProfile() -> UserProfile? {
        guard let username = usernameTextField.text, !username.isEmpty,
              let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let patronymic = patronymicTextField.text, !patronymic.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let gender = genderTextField.text, !gender.isEmpty,
              let genderLabel = genderLabel.text, !genderLabel.isEmpty,
              let country = countryTextField.text, !country.isEmpty,
              let countryLabel = countryLabelTextField.text, !countryLabel.isEmpty,
              let city = cityTextField.text, !city.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let cityIDString = cityIDTextField.text, let cityID = Int(cityIDString),
              let avatarURLString = avatarURL.text else {
            print("createUserProfile nil")
            return nil
        }
        
        let birthdayTimestamp = Int(birthdayDatePicker.date.timeIntervalSince1970)
        let avatarString = avatar.text ?? ""
        let isDoctor = isDoctorSwitch.isOn
        let isConfirmedDoctor = isConfirmedDoctorSwitch.isOn
        
        return UserProfile(
            username: username,
            first_name: firstName,
            last_name: lastName,
            patronymic: patronymic,
            birthday: birthdayTimestamp,
            email: email,
            gender: gender,
            gender_label: genderLabel,
            country: country,
            country_label: countryLabel,
            city_id: cityID,
            city: city,
            phone: phone,
            avatar: avatarString,
            avatar_url: avatarURLString,
            is_doctor: isDoctor,
            is_confirmed_doctor: isConfirmedDoctor
        )
    }
    
    private func bindViewModel() {
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            }
            .store(in: &cancellables)

        viewModel.$loginError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showAlert(with: "Error", message: error)
                    print(error)
                }
            }
            .store(in: &cancellables)

        viewModel.$isLoggedIn
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoggedIn in
                if isLoggedIn {
                    if let user = self?.viewModel.loggedInUser {
                        print(user)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func loginTapped() {
        guard let numberPhone = usernameTextField.text, !numberPhone.isEmpty else {
            showAlert(with: "Ошибка", message: "Пожалуйста, введите номер телефона.")
            return
        }

        guard let profile = createUserProfile() else {
            showAlert(with: "Ошибка", message: "Пожалуйста, заполните все поля.")
            return
        }

        Task {
            await viewModel.requestCode(phoneNumber: numberPhone)
            await viewModel.authenticateWithCode(phoneNumber: numberPhone, code: "1111")
            DispatchQueue.main.async {
                if let authInUser = self.viewModel.authInUser,
                   let numberPhone = self.usernameTextField.text {
                    self.newTokenTextView.isHidden = false
                    self.newTokenTextView.text = "access: \(authInUser.access)\n\nrefresh: \(authInUser.refresh)"
                    // Сохраняем токен в буфер обмена
                    UIPasteboard.general.string = "access: \(authInUser.access)\n\nrefresh: \(authInUser.refresh)"
                    // Отправляем токен и номер телефона в другой контроллер
                    self.coordinator?.onSendToken?(authInUser.access, numberPhone)
                } else if let error = self.viewModel.loginError {
                    self.showAlert(with: "Ошибка", message: error)
                }
            }
        }
    }

    private func updateUIWithTokenInfo(access: String, refresh: String, numberPhone: String) {
        DispatchQueue.main.async {
            self.newTokenTextView.isHidden = false
            self.newTokenTextView.text = "access: \(access)\nrefresh: \(refresh)"
            // Сохраняем токен в буфер обмена
            UIPasteboard.general.string = "access: \(access)\nrefresh: \(refresh)"
            // Отправляем токен и номер телефона в другой контроллер
            self.coordinator?.onSendToken?(access, numberPhone)
        }
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let timestamp = Int(picker.date.timeIntervalSince1970)
        birthDay.text = "\(timestamp)"
    }
    
    @objc func didTapDone() {
        birthDay.resignFirstResponder()
    }
    
    private func showAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
