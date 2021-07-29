//
//  LoginRouter.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import UIKit

final class LoginRouter: BaseRouter {
    var keychainProvider: (() -> KeychainService?)?
}

extension LoginRouter: LoginRouterInput {
    func push(_ vc: UIViewController, animated: Bool = false) {
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func popToRootVC(animated: Bool = false) {
        navigationController?.popToRootViewController(animated: animated)
    }
}
