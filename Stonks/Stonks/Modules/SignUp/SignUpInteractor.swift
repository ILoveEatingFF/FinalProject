//
//  SignUpInteractor.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import Foundation

final class SignUpInteractor {
	weak var output: SignUpInteractorOutput?
    
    private let keychainService: KeychainService
    private let databaseService: DatabaseServiceProtocol
    
    init(keychainService: KeychainService, databaseService: DatabaseServiceProtocol) {
        self.keychainService = keychainService
        self.databaseService = databaseService
    }
}

extension SignUpInteractor: SignUpInteractorInput {
    func isUsernameAvailable(_ login: String) -> Bool {
        do {
            let queryItem = GenericPassword(key: KeychainConstants.genericPasswordService, username: login)
            guard let _: String? = try keychainService.getObject(queryItem: queryItem) else {
                return true
            }
            return false
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func signUp(username: String, password: String) {
        if !isUsernameAvailable(username) {
            return
        }
        let genericPassword = GenericPassword(key: KeychainConstants.genericPasswordService, username: username)
        do {
            try keychainService.setValue(password, queryItem: genericPassword)
            databaseService.saveUser(username: username)
            output?.didSignUp(username: username, password: password)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
}
