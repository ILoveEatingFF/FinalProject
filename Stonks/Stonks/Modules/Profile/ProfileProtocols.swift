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
}

protocol ProfileViewOutput: class {
    func onTapLogOut()
}

protocol ProfileInteractorInput: class {
    func logOut()
}

protocol ProfileInteractorOutput: class {
    func didLogOut()
}

protocol ProfileRouterInput: class {
}
