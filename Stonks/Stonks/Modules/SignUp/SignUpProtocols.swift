//
//  SignUpProtocols.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import Foundation

protocol SignUpModuleInput {
	var moduleOutput: SignUpModuleOutput? { get }
}

protocol SignUpModuleOutput: class {
    func didSignUp(username: String, password: String)
}

protocol SignUpViewInput: class {
    func showErrors(_ errors: [SignUpViewController.Error])
}

protocol SignUpViewOutput: class {
    func signUp(email: String, login: String, password: String, repeatPassword: String)
}

protocol SignUpInteractorInput: class {
    func signUp(username: String, password: String)
    func isUsernameAvailable(_ username: String) -> Bool
}

protocol SignUpInteractorOutput: class {
    func didSignUp(username: String, password: String)
}

protocol SignUpRouterInput: class {
}
