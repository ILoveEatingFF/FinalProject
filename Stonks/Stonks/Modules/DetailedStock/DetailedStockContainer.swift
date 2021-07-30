import UIKit

final class DetailedStockContainer {
    let input: DetailedStockModuleInput
	let viewController: UIViewController
	private(set) weak var router: DetailedStockRouterInput!

	static func assemble(with context: DetailedStockContext) -> DetailedStockContainer {
        let router = DetailedStockRouter()
        let interactor = DetailedStockInteractor(
            databaseService: context.databaseService,
            defaultsService: context.defaultsService,
            networkService: context.networkService,
            accessibilityService: context.accessibilityService
        )
        let presenter = DetailedStockPresenter(
            router: router,
            interactor: interactor,
            currentShownStockSymbol: context.stock.symbol
        )
        let viewController = DetailedStockViewController(output: presenter, stock: context.stock)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter
        
        router.navigationControllerProvider = {[weak viewController] in
            viewController?.navigationController
        }

        return DetailedStockContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: DetailedStockModuleInput, router: DetailedStockRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct DetailedStockContext {
	weak var moduleOutput: DetailedStockModuleOutput?
    let stock: StockCardViewModel
    let databaseService: DatabaseServiceProtocol
    let defaultsService: StorageServiceProtocol
    let networkService: StockNetworkServiceProtocol
    let accessibilityService: AccessibilityServiceProtocol
}
