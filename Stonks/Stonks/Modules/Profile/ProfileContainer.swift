//
//  ProfileContainer.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import UIKit

final class ProfileContainer {
    let input: ProfileModuleInput
	let viewController: UIViewController
	private(set) weak var router: ProfileRouterInput!

	static func assemble(with context: ProfileContext) -> ProfileContainer {
        let router = ProfileRouter()
        let interactor = ProfileInteractor(defaultsService: context.defaultsService)
        let presenter = ProfilePresenter(router: router, interactor: interactor)
		let viewController = ProfileViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter

        return ProfileContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: ProfileModuleInput, router: ProfileRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct ProfileContext {
	weak var moduleOutput: ProfileModuleOutput?
    let defaultsService: StorageServiceProtocol
}
