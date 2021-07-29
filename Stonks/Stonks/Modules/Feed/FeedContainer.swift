//
//  FeedContainer.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import UIKit

final class FeedContainer {
    let input: FeedModuleInput
	let viewController: UIViewController
	private(set) weak var router: FeedRouterInput!

	static func assemble(with context: FeedContext) -> FeedContainer {
        let router = FeedRouter()
        let interactor = FeedInteractor(
            networkService: context.networkService,
            databaseService: context.databaseService,
            defaultService: context.defaultService,
            accessibilityService: context.accessibilityService
        )
        let presenter = FeedPresenter(router: router, interactor: interactor)
        let viewController = FeedViewController(output: presenter, imageLoader: context.imageLoader)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter
        
        router.navigationControllerProvider = {[weak viewController] in
            return viewController?.navigationController
        }
        
        router.defaultsServiceProvider = { [context] in
            return context.defaultService
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

        return FeedContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: FeedModuleInput, router: FeedRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct FeedContext {
	weak var moduleOutput: FeedModuleOutput?
    let networkService: StockNetworkServiceProtocol
    let imageLoader: ImageLoaderProtocol
    let databaseService: DatabaseServiceProtocol
    let defaultService: StorageServiceProtocol
    let accessibilityService: AccessibilityServiceProtocol
}
