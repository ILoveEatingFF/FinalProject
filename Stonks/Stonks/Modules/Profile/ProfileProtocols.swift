//
//  ProfileProtocols.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import Foundation

protocol ProfileModuleInput {
	var moduleOutput: ProfileModuleOutput? { get }
}

protocol ProfileModuleOutput: class {
    func didLogOut()
}

protocol ProfileViewInput: class {
    func updateUsername(_ username: String)
}

protocol ProfileViewOutput: class {
    func onTapLogOut()
    func getUsername()
}

protocol ProfileInteractorInput: class {
    func logOut()
    func getUsername() -> String
}

protocol ProfileInteractorOutput: class {
    func didLogOut()
}

protocol ProfileRouterInput: class {
}
