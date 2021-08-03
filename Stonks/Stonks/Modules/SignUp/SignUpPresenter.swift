//
//  SignUpPresenter.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import Foundation

final class SignUpPresenter {
	weak var view: SignUpViewInput?
    weak var moduleOutput: SignUpModuleOutput?
    
	private let router: SignUpRouterInput
	private let interactor: SignUpInteractorInput
    
    init(router: SignUpRouterInput, interactor: SignUpInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension SignUpPresenter: SignUpModuleInput {
}

extension SignUpPresenter: SignUpViewOutput {
    func signUp(email: String, login: String, password: String, repeatPassword: String) {
        guard isValid(email: email, login: login, password: password, repeatPassword: repeatPassword) else {
            return
        }
        interactor.signUp(username: login, password: password)
    }
    
}

extension SignUpPresenter: SignUpInteractorOutput {
    func didSignUp(username: String, password: String) {
        moduleOutput?.didSignUp(username: username, password: password)
    }
}

// MARK: - Private

private extension SignUpPresenter {
    func isValid(email: String, login: String, password: String, repeatPassword: String) -> Bool {
        var errors: [SignUpViewController.Error] = []
        if !isEmailValid(email) {
            errors += [.email]
        }
        
        if !isLoginValid(login) {
            errors += [.login]
        }
        
        if !isLoginHasMoreThanFourSymbols(login) {
            errors += [.loginHasLessThanFourSymbols]
        }
        
        if !isPasswordValid(password) {
            errors += [.password]
        }
        
        if !isRepeatPasswordValid(password: password, repeatPassword: repeatPassword) {
            errors += [.repeatPassword]
        }
        
        view?.showErrors(errors)
        
        return errors.isEmpty
    }
    
    func isEmailValid(_ email: String) -> Bool {
        return email.isEmail()
    }
    
    func isLoginValid(_ login: String) -> Bool {
        return interactor.isUsernameAvailable(login)
    }
    
    func isLoginHasMoreThanFourSymbols(_ login: String) -> Bool {
        return login.count > 4
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        return password.isPassword()
    }
    
    func isRepeatPasswordValid(password: String, repeatPassword: String) -> Bool {
        return password == repeatPassword
    }
}
