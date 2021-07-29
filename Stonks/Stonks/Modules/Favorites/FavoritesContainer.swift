//
//  FavoritesContainer.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import UIKit

final class FavoritesContainer {
    let input: FavoritesModuleInput
	let viewController: UIViewController
	private(set) weak var router: FavoritesRouterInput!

	static func assemble(with context: FavoritesContext) -> FavoritesContainer {
        let router = FavoritesRouter()
        let interactor = FavoritesInteractor(
            networkService: context.networkService,
            databaseService: context.databaseService,
            defaultsService: context.defaultsService,
            accessibilityService: context.accessibilityService
        )
        let presenter = FavoritesPresenter(router: router, interactor: interactor)
        let viewController = FavoritesViewController(output: presenter, imageLoader: context.imageLoader)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter
        
        router.navigationControllerProvider = {[weak viewController] in
            return viewController?.navigationController
        }
        
        router.defaultsServiceProvider = { [context] in
            return context.defaultsService
        }
        router.databaseServiceProvider = { [context] in
            return context.databaseService
        }
        router.networkServiceProvider = { [context] in
            return context.networkService
        }
        router.accessibilityServiceProvider = {[context] in
            return context.accessibilityService
        }

        return FavoritesContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: FavoritesModuleInput, router: FavoritesRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct FavoritesContext {
	weak var moduleOutput: FavoritesModuleOutput?
    let networkService: StockNetworkServiceProtocol
    let databaseService: DatabaseServiceProtocol
    let defaultsService: StorageServiceProtocol
    let accessibilityService: AccessibilityServiceProtocol
    let imageLoader: ImageLoaderProtocol
}
