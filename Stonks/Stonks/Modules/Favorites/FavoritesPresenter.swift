//
//  FavoritesPresenter.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import Foundation

final class FavoritesPresenter {
	weak var view: FavoritesViewInput?
    weak var moduleOutput: FavoritesModuleOutput?
    
	private let router: FavoritesRouterInput
	private let interactor: FavoritesInteractorInput
    
    private var shouldReload = false
    
    init(router: FavoritesRouterInput, interactor: FavoritesInteractorInput) {
        self.router = router
        self.interactor = interactor
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeFavorite), name: .didChangeFavorite, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didChangeFavorite, object: nil)
    }
    
    @objc
    private func onChangeFavorite(_ notifictation: Notification) {
        shouldReload = true
    }
}

extension FavoritesPresenter: FavoritesModuleInput {
}

extension FavoritesPresenter: FavoritesViewOutput {
    func filter(stonks: [StockCardViewModel], with searchText: String) {
        var result: [StockCardViewModel] = []
        stonks.forEach {
            if ($0.symbol.lowercased()).starts(with: searchText) || $0.description.lowercased().starts(with: searchText) {
                result.append($0)
            }
        }
        view?.updateFiltered(with: result)
    }
    
    func willViewAppear() {
        if shouldReload {
            interactor.reload()
            shouldReload = false
        }
    }
    
    func didLoadView() {
        interactor.load()
    }
    
    func onTapFavorite(with symbol: String) {
        interactor.deleteFavorite(with: symbol)
    }
    
}

extension FavoritesPresenter: FavoritesInteractorOutput {
    func didLoad(with stonks: [StonkDTO]) {
        let viewModels = makeViewModels(from: stonks)
        view?.update(with: viewModels)
    }
    
}

private extension FavoritesPresenter {
    func makeViewModels(from stonks: [StonkDTO]) -> [StockCardViewModel] {
        var models: [StockCardViewModel] = []
        models = stonks.enumerated().map { (index, stonk) -> StockCardViewModel in
            let changeColor: StockCardViewModel.ChangeColor = stonk.quote.change ?? 0 < 0 ? .red : .green
            let price: String = stonk.quote.latestPrice != nil ? String(stonk.quote.latestPrice!.roundToDecimal(3)) : ""
            let change: String = stonk.quote.change != nil ? String(stonk.quote.change!.roundToDecimal(3)) : ""
            let isFavorite: Bool = stonk.isFavorite != nil ? stonk.isFavorite! : false
            return StockCardViewModel(
                symbol: stonk.quote.symbol,
                description: stonk.quote.companyName,
                price: price ,
                change: change,
                logo: stonk.logo.url ?? "",
                changeColor: changeColor,
                backgroundColor: index % 2 == 0 ? .lightGray : .lightBlue,
                isFavorite: isFavorite
            )
        }
        return models
    }
}
