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
    private lazy var nickNameTextField: UITextField = {
        appView.textField(placeholder: "Nick name")
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
    private lazy var avatarTextField: UITextField = {
        appView.textField(placeholder: "Avatar")
    }()
    private lazy var avatarURLTextField: UITextField = {
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
        
        contentView.addSubview(phoneTextField)
        setupConstraintsForView(phoneTextField, below: lastView, isTopView: true)
        lastView = phoneTextField
        
        contentView.addSubview(nickNameTextField)
        setupConstraintsForView(nickNameTextField, below: lastView)
        lastView = nickNameTextField
        
        contentView.addSubview(firstNameTextField)
        setupConstraintsForView(firstNameTextField, below: lastView)
        lastView = firstNameTextField
        
        contentView.addSubview(lastNameTextField)
        setupConstraintsForView(lastNameTextField, below: lastView)
        lastView = lastNameTextField
        
        contentView.addSubview(patronymicTextField)
        setupConstraintsForView(patronymicTextField, below: lastView)
        lastView = patronymicTextField
        
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
        
        contentView.addSubview(birthDay)
        setupConstraintsForView(birthDay, below: lastView)
        lastView = birthDay
        
        contentView.addSubview(emailTextField)
        setupConstraintsForView(emailTextField, below: lastView)
        lastView = emailTextField
        
        contentView.addSubview(genderTextField)
        setupConstraintsForView(genderTextField, below: lastView)
        lastView = genderTextField
        
        contentView.addSubview(genderLabel)
        setupConstraintsForView(genderLabel, below: lastView)
        lastView = genderLabel
        
        contentView.addSubview(countryTextField)
        setupConstraintsForView(countryTextField, below: lastView)
        lastView = countryTextField
        
        contentView.addSubview(countryLabelTextField)
        setupConstraintsForView(countryLabelTextField, below: lastView)
        lastView = countryLabelTextField
        
        contentView.addSubview(cityIDTextField)
        setupConstraintsForView(cityIDTextField, below: lastView)
        lastView = cityIDTextField
        
        contentView.addSubview(cityTextField)
        setupConstraintsForView(cityTextField, below: lastView)
        lastView = cityTextField
        
        contentView.addSubview(avatarTextField)
        setupConstraintsForView(avatarTextField, below: lastView)
        lastView = avatarTextField
        
        contentView.addSubview(avatarURLTextField)
        setupConstraintsForView(avatarURLTextField, below: lastView)
        lastView = avatarURLTextField
        
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
        
        contentView.addSubview(loginButton)
        setupConstraintsForView(loginButton, below: lastView)
        lastView = loginButton
        
        newTokenTextView.isHidden = true
        contentView.addSubview(newTokenTextView)
        setupConstraintsForView(newTokenTextView, below: lastView)
        
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
            
            switch view {
            case is UITextField:
                make.height.equalTo(40)
            case is UIDatePicker:
                make.height.equalTo(100)
            case is UIButton:
                make.height.equalTo(50)
            case is UISegmentedControl:
                make.height.equalTo(30)
            case is UISwitch:
                make.height.equalTo(31)
            default:
                break
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
        guard let nickname = nickNameTextField.text?.isEmpty ?? true ? "-" : nickNameTextField.text,
              let firstName = firstNameTextField.text?.isEmpty ?? true ? "-" : firstNameTextField.text,
              let lastName = lastNameTextField.text?.isEmpty ?? true ? "-" : lastNameTextField.text,
              let email = emailTextField.text?.isEmpty ?? true ? "shamil.aglarov@gmail.com" : emailTextField.text,
              let countryLabel = countryLabelTextField.text?.isEmpty ?? true ? "Russia" : countryLabelTextField.text,
              let phone = phoneTextField.text?.isEmpty ?? true ? "" : phoneTextField.text,
              let patronymic = patronymicTextField.text?.isEmpty ?? true ? "-" : patronymicTextField.text,
              let gender = genderTextField.text?.isEmpty ?? true ? "male" : genderTextField.text,
              let country = countryTextField.text?.isEmpty ?? true ? "RU" : countryTextField.text,
              let city = cityTextField.text?.isEmpty ?? true ? "-" : cityTextField.text,
              let avatar = avatarTextField.text?.isEmpty ?? true ? "avatar" : avatarTextField.text,
              let avatarURL = avatarURLTextField.text?.isEmpty ?? true ? "avatar.jpeg" : avatarURLTextField.text else {
            return nil
        }
        
        let cityID = Int(cityIDTextField.text ?? "1") ?? 1
        let birthdayTimestamp = Int(birthdayDatePicker.date.timeIntervalSince1970)
        let isDoctor = isDoctorSwitch.isOn
        let isConfirmedDoctor = isConfirmedDoctorSwitch.isOn
        
        let userProfile = UserProfile(
            nickname: nickname,
            first_name: firstName,
            last_name: lastName,
            patronymic: patronymic,
            birthday: birthdayTimestamp,
            email: email,
            gender: gender,
            gender_label: gender,
            country: country,
            country_label: countryLabel,
            city_id: cityID,
            city: city,
            phone: phone,
            avatar: avatar,
            avatar_url: avatarURL,
            is_doctor: isDoctor,
            is_confirmed_doctor: isConfirmedDoctor
        )
        print("USER_PROFILE: \(userProfile)")
        return userProfile
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showAlert(with: "Error", message: error)
                    print(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                if isLoggedIn {
                    if let user = self?.viewModel.loggedInUser {
                        print("USER-1 \(user)")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func loginTapped() {
        guard let numberPhone =  phoneTextField.text else {
            showAlert(with: "Ошибка", message: "Пожалуйста, введите номер телефона.")
            return
        }
        
        guard let profile = createUserProfile() else {
            showAlert(with: "Ошибка", message: "Пожалуйста, заполните обязательные поля.")
            return
        }
        
        Task {
            await viewModel.requestCode(phoneNumber: numberPhone)
            await viewModel.authenticateWithCode(phoneNumber: numberPhone, code: "1111")
            
            if let authInUser = self.viewModel.authInUser {
                // Обновляем UI
                updateUIWithTokenInfo(access: authInUser.access, refresh: authInUser.refresh, numberPhone: numberPhone)
                
                await viewModel.perform(userData: profile, fromToken: authInUser.access)
            } else if let error = self.viewModel.loginError {
                DispatchQueue.main.async {
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
