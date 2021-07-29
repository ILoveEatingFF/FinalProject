//
//  LoginViewController.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
	private let output: LoginViewOutput
    
    private let stackView = UIStackView()
    
    private let signInErrorLabel = ErrorLabel()
    private lazy var loginTextField = PaddingTextField()
    private lazy var passwordTextField = PaddingTextField()
    
    private let loginButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)
    
    private lazy var safeAreaGuide = view.safeAreaLayoutGuide

    // MARK: - Lifecycle
    
    init(output: LoginViewOutput) {
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
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(signInErrorLabel)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(signUpButton)
        
        stackView.setCustomSpacing(15.0, after: passwordTextField)
        
        loginTextField.placeholder = Constants.Text.loginTF
        loginTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        passwordTextField.placeholder = Constants.Text.passwordTF
        passwordTextField.isSecureTextEntry = true
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        setupLoginButton()
        
        signUpButton.setTitle(Constants.Text.signUpButton, for: .normal)
        signUpButton.addTarget(self, action: #selector(onTapSignUp), for: .touchUpInside)
        
        signInErrorLabel.text = Constants.Text.signInError
    }
    
    private func setupConstraints() {
        [loginTextField,
         passwordTextField,
         loginButton,
         signUpButton,
         stackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            
            stackView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor,constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor,constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: signUpButton.bottomAnchor)
        ])
    }
    
    private func setupLoginButton() {
        loginButton.backgroundColor = Color.lightBlack
        loginButton.setTitle(Constants.Text.loginButton, for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(onTapLoginButton), for: .touchUpInside)
        setLoginButton(as: .unclickable)
    }
    
    @objc
    private func onTapLoginButton() {
        guard
            let username = loginTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        signInErrorLabel.isHidden = true
        self.output.login(username: username, password: password)
    }
    
    @objc
    private func onTapSignUp() {
        signInErrorLabel.isHidden = true
        self.output.signUp()
    }
    
    @objc
    private func textFieldDidChange() {
        guard
            let username = loginTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        if password.isEmpty || username.isEmpty {
            setLoginButton(as: .unclickable)
        } else {
            setLoginButton(as: .clickable)
        }
    }
    
    private func setLoginButton(as style: LoginButtonStyle) {
        switch style {
        case .clickable:
            loginButton.isEnabled = true
            loginButton.backgroundColor = loginButton.backgroundColor?.withAlphaComponent(1)
        case .unclickable:
            loginButton.isEnabled = false
            loginButton.backgroundColor = loginButton.backgroundColor?.withAlphaComponent(0.3)
        }
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {
    func setUsernameAndPassword(username: String, password: String) {
        loginTextField.text = username
        passwordTextField.text = password
        setLoginButton(as: .clickable)
    }
    
    func showSignInError() {
        signInErrorLabel.isHidden = false
    }
}

// MARK: - Nested Types

private extension LoginViewController {
    enum Constants {
        enum Text {
            static let loginTF = "Логин"
            static let passwordTF = "Пароль"
            static let loginButton = "Войти"
            static let signUpButton = "Регистрация"
            static let signInError = "Неверный логин или пароль"
        }
    }
    
    enum LoginButtonStyle {
        case clickable
        case unclickable
    }
}
