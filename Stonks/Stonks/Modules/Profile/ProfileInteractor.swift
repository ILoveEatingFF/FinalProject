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
    private let defaultsService: StorageServiceProtocol
    
    init(defaultsService: StorageServiceProtocol) {
        self.defaultsService = defaultsService
    }
}

extension ProfileInteractor: ProfileInteractorInput {
    func getUsername() -> String {
        let username: String? = defaultsService.get(for: DefaultsConstants.currentUserKey)
        return username ?? ""
    }
    
    func logOut() {
        defaultsService.remove(for: DefaultsConstants.currentUserKey)
        output?.didLogOut()
    }
    
}
