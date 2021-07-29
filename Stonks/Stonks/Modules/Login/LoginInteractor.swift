//
//  LoginInteractor.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import Foundation

final class LoginInteractor {
	weak var output: LoginInteractorOutput?
    
    private let keychainService: KeychainService
    private let storageService: StorageServiceProtocol
    
    init(
        keychainService: KeychainService,
        storageService: StorageServiceProtocol
    ) {
        self.keychainService = keychainService
        self.storageService = storageService
    }
}

extension LoginInteractor: LoginInteractorInput {
    func signIn(username: String, password: String) {
        let genericPassword = GenericPassword(key: KeychainConstants.genericPasswordService, username: username)
        guard
            let keychainPassword: String? = try? keychainService.getObject(queryItem: genericPassword),
            password == keychainPassword
            else {
            output?.didNotSignIn()
            return
        }
        storageService.save(object: username, for: DefaultsConstants.currentUserKey)
        output?.didSignIn()
    }
    
}
