//
//  LoginPresenter.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import Foundation

final class LoginPresenter {
	weak var view: LoginViewInput?
    weak var moduleOutput: LoginModuleOutput?
    
	private let router: LoginRouterInput
	private let interactor: LoginInteractorInput
    
    init(router: LoginRouterInput, interactor: LoginInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension LoginPresenter: LoginModuleInput {
    func didSignUp(username: String, password: String) {
        view?.setUsernameAndPassword(username: username, password: password)
    }
}

extension LoginPresenter: LoginViewOutput {
    func login(username: String, password: String) {
        interactor.signIn(username: username, password: password)
    }
    
    func signUp() {
        moduleOutput?.showSignUp()
    }
}

extension LoginPresenter: LoginInteractorOutput {
    func didSignIn() {
        moduleOutput?.startApp()
    }
    
    func didNotSignIn() {
        view?.showSignInError()
    }
}
