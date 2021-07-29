import Foundation

final class DetailedStockPresenter {
	weak var view: DetailedStockViewInput?
    weak var moduleOutput: DetailedStockModuleOutput?
    
	private let router: DetailedStockRouterInput
	private let interactor: DetailedStockInteractorInput
    
    private var currentShownStockSymbol: String
    
    init(
        router: DetailedStockRouterInput,
        interactor: DetailedStockInteractorInput,
        currentShownStockSymbol: String
    ) {
        self.router = router
        self.interactor = interactor
        self.currentShownStockSymbol = currentShownStockSymbol
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeFavorite(_:)), name: .didChangeFavorite, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didChangeFavorite, object: nil)
    }
    
    @objc
    private func onChangeFavorite(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: String],
            let symbol = userInfo["symbol"],
            currentShownStockSymbol == symbol
        else {
            return
        }
        let isFavorite = interactor.isStockFavorite(with: currentShownStockSymbol)
        view?.updateFavorite(isFavorite: isFavorite)
    }
}

extension DetailedStockPresenter: DetailedStockModuleInput {
}

extension DetailedStockPresenter: DetailedStockViewOutput {
    func didTapNews(symbol: String) {
        interactor.loadNews(symbol: symbol, lastNews: 50)
    }
    
    func didTapOnFavorite(symbol: String, isFavorite: Bool) {
        interactor.saveOrDeleteFavorite(symbol: symbol, isFavorite: isFavorite)
    }
    
}

extension DetailedStockPresenter: DetailedStockInteractorOutput {
    func didLoadNews(_ news: [News]) {
        let viewModels = makeNewsViewModels(news)
        view?.updateNews(with: viewModels)
    }
}

private extension DetailedStockPresenter {
    func makeNewsViewModels(_ news: [News]) -> [NewsViewModel] {
        news.map {
            NewsViewModel(
                headline: $0.headline ?? "",
                source: $0.source ?? "",
                url: $0.url ?? "",
                summary: $0.summary ?? "",
                image: $0.image ?? "")
        }
    }
}
