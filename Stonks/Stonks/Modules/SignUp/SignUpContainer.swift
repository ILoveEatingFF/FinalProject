//
//  SignUpContainer.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//  
//

import UIKit

final class SignUpContainer {
    let input: SignUpModuleInput
	let viewController: UIViewController
	private(set) weak var router: SignUpRouterInput!

	static func assemble(with context: SignUpContext) -> SignUpContainer {
        let router = SignUpRouter()
        let interactor = SignUpInteractor(
            keychainService: context.keychainService,
            databaseService: context.databaseService
        )
        let presenter = SignUpPresenter(router: router, interactor: interactor)
		let viewController = SignUpViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter

        return SignUpContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: SignUpModuleInput, router: SignUpRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct SignUpContext {
	weak var moduleOutput: SignUpModuleOutput?
    let keychainService: KeychainService
    let databaseService: DatabaseServiceProtocol
}
