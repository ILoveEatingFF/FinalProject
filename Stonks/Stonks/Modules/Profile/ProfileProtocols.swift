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
}

protocol ProfileViewInput: class {
}

protocol ProfileViewOutput: class {
}

protocol ProfileInteractorInput: class {
}

protocol ProfileInteractorOutput: class {
}

protocol ProfileRouterInput: class {
}
