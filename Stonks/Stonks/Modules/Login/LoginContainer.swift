//
//  LoginContainer.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import UIKit

final class LoginContainer {
    let input: LoginModuleInput
	let viewController: UIViewController
	private(set) weak var router: LoginRouterInput!

	static func assemble(with context: LoginContext) -> LoginContainer {
        let router = LoginRouter()
        let interactor = LoginInteractor(
            keychainService: context.keychainService,
            storageService: context.defaultsService
        )
        let presenter = LoginPresenter(router: router, interactor: interactor)
		let viewController = LoginViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter
        
        router.navigationControllerProvider = { [weak viewController] in
            return viewController?.navigationController
        }

        return LoginContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: LoginModuleInput, router: LoginRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct LoginContext {
	weak var moduleOutput: LoginModuleOutput?
    let keychainService: KeychainService
    let defaultsService: StorageServiceProtocol
}
