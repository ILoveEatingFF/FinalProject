import Foundation

final class DetailedStockPresenter {
	weak var view: DetailedStockViewInput?
    weak var moduleOutput: DetailedStockModuleOutput?
    
	private let router: DetailedStockRouterInput
	private let interactor: DetailedStockInteractorInput
    
    private var currentShownStockSymbol: String
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
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
    func didTapBasicFinancials(symbol: String) {
        interactor.loadBasicFinancials(symbol: symbol)
    }
    
    func didTapNewsItem(_ url: String) {
        router.showNews(with: url)
    }
    
//     Рекомендовано использовать загрузку по дате, так как апишка по дате не имеет таких сильных
//    ограничений как апишка по количеству последний новостей
    func didTapNewsSegment(symbol: String) {
        loadNews(with: symbol, loadType: .byDate)
    }
    
    func didTapOnFavorite(symbol: String, isFavorite: Bool) {
        interactor.saveOrDeleteFavorite(symbol: symbol, isFavorite: isFavorite)
    }
    
    private func loadNews(with symbol: String, loadType: NewsLoadType) {
        switch loadType {
        case .byDate:
            interactor.loadNews(symbol: symbol, startDate: Date().monthAgo, endDate: Date())
        case .byLastCount:
            interactor.loadNews(symbol: symbol, lastNews: 50)
        }
    }
}

extension DetailedStockPresenter: DetailedStockInteractorOutput {
    func didLoadBasicFinancials(_ metric: Metric) {
        let viewModel = makeBasicFinancialsViewModel(metric)
        view?.updateBasicFinancials(with: viewModel)
    }
    
    func didLoadNews(_ news: [News]) {
        let viewModels = makeNewsViewModels(news)
        view?.updateNews(with: viewModels)
    }
}

private extension DetailedStockPresenter {
    func makeBasicFinancialsViewModel(_ metric: Metric) -> BasicFinancialsViewModel {
        BasicFinancialsViewModel(
            tenDayAverageTradingVolume: "\(metric.tenDayAverageTradingVolume?.roundToDecimal(3) ?? 0)",
            weekHigh52: "\(metric.weekHigh52?.roundToDecimal(3) ?? 0)",
            weekLow52: "\(metric.weekLow52?.roundToDecimal(3) ?? 0)",
            weekPriceReturnDaily52: "\(metric.weekPriceReturnDaily52?.roundToDecimal(3) ?? 0)",
            marketCapitalization: "\(metric.marketCapitalization?.roundToDecimal(3) ?? 0)",
            beta: "\(metric.beta?.roundToDecimal(3) ?? 0)"
        )
    }
    
    func makeNewsViewModels(_ news: [News]) -> [NewsViewModel] {
        news
            .sorted {$0.datetime ?? 0 > $1.datetime ?? 0}
            .map {
//                let date = Date.init(milliseconds: $0.datetime ?? 0)
                let date = Date(timeIntervalSince1970: $0.datetime ?? 0)
                return NewsViewModel(
                    headline: $0.headline ?? "",
                    source: $0.source ?? "",
                    url: $0.url ?? "",
                    summary: $0.summary ?? "",
                    image: $0.image ?? "",
                    date: dateFormatter.string(from: date))
            }
    }
}

// MARK: - Nested types

private extension DetailedStockPresenter {
    enum NewsLoadType {
        case byDate
        case byLastCount
    }
}
