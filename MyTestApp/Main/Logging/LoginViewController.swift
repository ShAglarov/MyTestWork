//
//  ViewController.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import UIKit
import SnapKit
import Moya
import Combine

final class LoginViewController: UIViewController {

    private var viewModel = LoginViewModel()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var coordinator: LoginCoordinator?
    private let provider = MoyaProvider<JSONPlaceholderAPI>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    let appView = AppView()

    lazy var usernameTextField: UITextField = {
        appView.textField(placeholder: "Логин",isSecureTextEntry: false)
    }()
    
    lazy var passwordTextField: UITextField = {
        appView.textField(placeholder: "Пароль")
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
    }
    
    private func bindViewModel() {
        viewModel.$isLoading.sink { isLoading in
            if isLoading {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }.store(in: &cancellables)

        viewModel.$loginError.sink { [weak self] error in
            if let error = error {
                self?.showAlert(with: "Error", message: error)
            }
        }.store(in: &cancellables)

        viewModel.$isLoggedIn.sink { [weak self] isLoggedIn in
            if isLoggedIn {
                print(self?.viewModel.username ?? "")
            }
        }.store(in: &cancellables)
    }
    
    @objc private func loginTapped() {
        viewModel.username = usernameTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.login()
    }
    
    private func showAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

