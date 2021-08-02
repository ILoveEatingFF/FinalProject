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

protocol ProfileModuleOutput: AnyObject {
    func didLogOut()
}

protocol ProfileViewInput: AnyObject {
    func updateUsername(_ username: String)
}

protocol ProfileViewOutput: AnyObject {
    func onTapLogOut()
    func getUsername()
}

protocol ProfileInteractorInput: AnyObject {
    func logOut()
    func getUsername() -> String
}

protocol ProfileInteractorOutput: AnyObject {
    func didLogOut()
}

protocol ProfileRouterInput: AnyObject {
}
