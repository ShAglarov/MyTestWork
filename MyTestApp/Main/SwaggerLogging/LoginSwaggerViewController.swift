//
//  LoginSwaggerViewController.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 07.11.2023.
//

import UIKit
import SnapKit
import Combine

final class LoginSwaggerViewController: UIViewController {

    private var viewModel = LoginSwaggerViewModel()
    
    init(viewModel: LoginSwaggerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var coordinator: SwaggerLoginCoordinator?
    private let provider = NetworkSwagger()
    
    private var cancellables: Set<AnyCancellable> = []
    
    let appView = AppView()

    lazy var usernameTextField: UITextField = {
        appView.textField(placeholder: "Логин")
    }()
    
    lazy var passwordTextField: UITextField = {
        appView.textField(placeholder: "Пароль", isSecureTextEntry: true)
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
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
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.left.right.equalTo(usernameTextField)
            make.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        usernameTextField.text = "+7"
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
        viewModel.password = passwordTextField.text ?? ""
        // Запускаем асинхронную задачу для входа в систему
        Task {
            await viewModel.performLogin()
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
