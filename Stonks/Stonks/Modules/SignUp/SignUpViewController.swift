//
//  SignUpViewController.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import UIKit

final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
	private let output: SignUpViewOutput
    
    private let signUpStackView = UIStackView()
    
    private let emailStack = UIStackView()
    private let emailTextField = PaddingTextField()
    private let emailErrorLabel = ErrorLabel()
    
    private let loginStack = UIStackView()
    private let loginTextField = PaddingTextField()
    private let loginErrorLabel = ErrorLabel()
    
    private let passwordStack = UIStackView()
    private let passwordTextField = PaddingTextField()
    private let passwordErrorLabel = ErrorLabel()
    
    private let repeatPasswordStack = UIStackView()
    private let repeatPasswordTextField = PaddingTextField()
    private let repeatPasswordErrorLabel = ErrorLabel()
    
    private let signUpButton = UIButton(type: .system)

    // MARK: - Lifecycle
    
    init(output: SignUpViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        setup()
        setupConstraints()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}
    
    // MARK: - Private
    
    private func setup() {
        view.addSubview(signUpStackView)
        view.addSubview(signUpButton)
        
        signUpStackView.axis = .vertical
        signUpStackView.spacing = 10.0
        
        signUpButton.backgroundColor = Color.lightBlack
        signUpButton.setTitle("Зарегистрироваться", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(onTapSignUp), for: .touchUpInside)
        
        setupEmail()
        setupLogin()
        setupPassword()
        setupRepeatPassword()
    }
    
    private func setupEmail() {
        signUpStackView.addArrangedSubview(emailStack)
        
        emailStack.axis = .vertical
        
        emailStack.addArrangedSubview(emailTextField)
        emailStack.addArrangedSubview(emailErrorLabel)
        
        emailTextField.placeholder = Constants.TextField.emailPlaceholder
        emailErrorLabel.text = Constants.ErrorLabel.emailText
    }
    
    private func setupLogin() {
        signUpStackView.addArrangedSubview(loginStack)
        
        loginStack.axis = .vertical
        
        loginStack.addArrangedSubview(loginTextField)
        loginStack.addArrangedSubview(loginErrorLabel)
        
        loginTextField.placeholder = Constants.TextField.loginPlaceholder
        loginErrorLabel.text = Constants.ErrorLabel.loginText
    }
    
    private func setupPassword() {
        signUpStackView.addArrangedSubview(passwordStack)
        
        passwordStack.axis = .vertical
        
        passwordStack.addArrangedSubview(passwordTextField)
        passwordStack.addArrangedSubview(passwordErrorLabel)
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = Constants.TextField.passwordPlaceholder
        passwordErrorLabel.text = Constants.ErrorLabel.passwordText
    }
    
    private func setupRepeatPassword() {
        signUpStackView.addArrangedSubview(repeatPasswordStack)
        
        repeatPasswordStack.axis = .vertical
        
        repeatPasswordStack.addArrangedSubview(repeatPasswordTextField)
        repeatPasswordStack.addArrangedSubview(repeatPasswordErrorLabel)
        
        repeatPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.placeholder = Constants.TextField.repeatPasswordPlaceholder
        repeatPasswordErrorLabel.text = Constants.ErrorLabel.repeatPasswordText
    }
    
    private func setupConstraints() {
        [signUpStackView,
         signUpButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            signUpStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            signUpStackView.bottomAnchor.constraint(equalTo: repeatPasswordStack.bottomAnchor),
            signUpStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16.0),
            signUpStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16.0),
            
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.height),
            loginTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.height),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.height),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.height),
            
            signUpButton.topAnchor.constraint(equalTo: signUpStackView.bottomAnchor, constant: 20.0),
            signUpButton.heightAnchor.constraint(equalToConstant: 45.0),
            signUpButton.leadingAnchor.constraint(equalTo: signUpStackView.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: signUpStackView.trailingAnchor)
            
        ])
    }
    
    @objc private func onTapSignUp() {
        self.emailErrorLabel.isHidden = true
        self.loginErrorLabel.isHidden = true
        self.passwordErrorLabel.isHidden = true
        self.repeatPasswordErrorLabel.isHidden = true
        
        guard
            let email = emailTextField.text,
            let login = loginTextField.text,
            let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text
        else {
            return
        }
        output.signUp(email: email, login: login, password: password, repeatPassword: repeatPassword)
    }
}

// MARK: - SignUpViewInput

extension SignUpViewController: SignUpViewInput {
    func showErrors(_ errors: [Error]) {
        errors.forEach {
            switch $0 {
            case .email:
                self.emailErrorLabel.isHidden = false
            case .login:
                self.loginErrorLabel.isHidden = false
            case .password:
                self.passwordErrorLabel.isHidden = false
            case .repeatPassword:
                self.repeatPasswordErrorLabel.isHidden = false
            }
        }
    }
    
}

// MARK: - Nested Types

extension SignUpViewController {
    enum Error {
        case email
        case login
        case password
        case repeatPassword
    }
    
}

private extension SignUpViewController {
    enum Constants {
        enum TextField {
            static let height: CGFloat = 50.0
            
            static let emailPlaceholder: String = "Ваш email"
            static let loginPlaceholder: String = "Ваш логин"
            static let passwordPlaceholder: String = "Пароль"
            static let repeatPasswordPlaceholder: String = "Подтвердите пароль"
        }
        
        enum ErrorLabel {
            static let emailText: String = "Адрес почты недействителен. Введите его в формате email@example.com"
            static let loginText: String = "Данный логин уже зарегистрирован"
            static let passwordText: String = "Пароль недействителен. Он должен быть больше 8 символов и содержать 1 большую букву, 1 маленькую и 1 цифру"
            static let repeatPasswordText: String = "Пароли не совпадают"
        }
        
    }
}
