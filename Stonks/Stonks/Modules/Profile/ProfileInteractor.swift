//
//  ProfileInteractor.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import Foundation

final class ProfileInteractor {
	weak var output: ProfileInteractorOutput?
}

extension ProfileInteractor: ProfileInteractorInput {
}
