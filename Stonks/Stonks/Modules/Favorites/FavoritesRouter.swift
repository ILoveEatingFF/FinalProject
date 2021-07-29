//
//  FavoritesRouter.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import UIKit

final class FavoritesRouter: BaseRouter {
    var defaultsServiceProvider: (() -> StorageServiceProtocol)?
    var databaseServiceProvider: (() -> DatabaseServiceProtocol)?
    var networkServiceProvider: (() -> StockNetworkServiceProtocol)?
    var accessibilityServiceProvider: (() -> AccessibilityServiceProtocol)?
}

extension FavoritesRouter: FavoritesRouterInput {
    func showDetailedStock(_ stock: StockCardViewModel) {
        guard
            let databaseService = databaseServiceProvider?(),
            let defaultsService = defaultsServiceProvider?(),
            let networkService = networkServiceProvider?(),
            let accessibilityService = accessibilityServiceProvider?()
        else {
            return
        }
        let context = DetailedStockContext(
            moduleOutput: nil,
            stock: stock,
            databaseService: databaseService,
            defaultsService: defaultsService,
            networkService: networkService,
            accessibilityService: accessibilityService
        )
        let container = DetailedStockContainer.assemble(with: context)
        navigationController?.pushViewController(container.viewController, animated: true)
    }
}
