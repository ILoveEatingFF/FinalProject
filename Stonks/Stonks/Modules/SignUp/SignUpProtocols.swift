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

protocol SignUpModuleOutput: AnyObject {
    func didSignUp(username: String, password: String)
}

protocol SignUpViewInput: AnyObject {
    func showErrors(_ errors: [SignUpViewController.Error])
}

protocol SignUpViewOutput: AnyObject {
    func signUp(email: String, login: String, password: String, repeatPassword: String)
}

protocol SignUpInteractorInput: AnyObject {
    func signUp(username: String, password: String)
    func isUsernameAvailable(_ username: String) -> Bool
}

protocol SignUpInteractorOutput: AnyObject {
    func didSignUp(username: String, password: String)
}

protocol SignUpRouterInput: AnyObject {
}
