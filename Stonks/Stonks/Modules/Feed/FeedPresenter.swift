//
//  FeedPresenter.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import Foundation

final class FeedPresenter {
	weak var view: FeedViewInput?
    weak var moduleOutput: FeedModuleOutput?
    
	private let router: FeedRouterInput
	private let interactor: FeedInteractorInput
    
    private var isLoading = false
    private(set) var hasNextPage = false
    private var shouldReloadFavorites = false
    
    init(router: FeedRouterInput, interactor: FeedInteractorInput) {
        self.router = router
        self.interactor = interactor
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeFavorite(_:)), name: .didChangeFavorite, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didChangeFavorite, object: nil)
    }
    
    @objc
    private func onChangeFavorite(_ notifictation: Notification) {
        shouldReloadFavorites = true
    }
}

extension FeedPresenter: FeedModuleInput {
}

extension FeedPresenter: FeedViewOutput {
    func willViewAppear() {
        if shouldReloadFavorites {
            interactor.reloadFavorites()
        }
    }
    
    func didTapOnFavorite(symbol: String, isFavorite: Bool) {
        interactor.saveOrDeleteFavorite(symbol: symbol, isFavorite: isFavorite)
    }
    
    func willDisplay(at index: Int, cellCount: Int) {
        guard
            index == cellCount - 1,
            !isLoading,
            hasNextPage
        else {
            return
        }
        interactor.loadNext()
    }
    
    func didSelectStock(_ stock: StockCardViewModel) {
        router.showDetailedStock(stock)
    }
    
    
    func reload() {
        
    }
    
    func didLoadView() {
        guard !isLoading else {
            return
        }
        isLoading = true
        interactor.load(with: .sp500)
    }
}

extension FeedPresenter: FeedInteractorOutput {
    func didLoadNextBatch(_ stonks: [StonkDTO], hasNextPage: Bool) {
        self.hasNextPage = hasNextPage
    }
    
    func didLoad(_ stonks: [StonkDTO], hasNextPage: Bool) {
        isLoading = false
        self.hasNextPage = hasNextPage
        let models = makeViewModels(from: stonks)
        view?.update(with: models)
    }
    
}

private extension FeedPresenter {
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
