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

    lazy var usernameTextField: UITextField = {
        appView.textField(placeholder: "Номер телефона")
    }()
    
    private lazy var loginButton: UIButton = {
        appView.button(title: "Отправить смс", backgroundColor: .blue, action: #selector(loginTapped), target: self)
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
        
        setupUI()
        
        // Настраиваем привязку к ViewModel
        bindViewModel()
        
    }
    private func setupUI() {
        view.addSubview(usernameTextField)
        view.addSubview(loginButton)
        view.addSubview(newTokenTextView)
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        usernameTextField.text = "+7"
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        newTokenTextView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(40)
            make.height.lessThanOrEqualTo(200)
        }
        newTokenTextView.isHidden = true
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
        viewModel.userName = usernameTextField.text ?? ""

        Task {
            guard let numberPhone = usernameTextField.text else { return }
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
    
    private func showAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
