import Foundation

protocol DetailedStockModuleInput {
	var moduleOutput: DetailedStockModuleOutput? { get }
}

protocol DetailedStockModuleOutput: class {
}

protocol DetailedStockViewInput: class {
    func updateFavorite(isFavorite: Bool)
    func updateNews(with viewModels: [NewsViewModel])
    func updateBasicFinancials(with viewModel: BasicFinancialsViewModel)
}

protocol DetailedStockViewOutput: class {
    func didTapOnFavorite(symbol: String, isFavorite: Bool)
    func didTapBasicFinancials(symbol: String)
    func didTapNewsSegment(symbol: String)
    func didTapNewsItem(_ url: String)
}

protocol DetailedStockInteractorInput: class {
    func saveOrDeleteFavorite(symbol: String, isFavorite: Bool)
    func isStockFavorite(with symbol: String) -> Bool
    func loadNews(symbol: String, lastNews: Int)
    func loadBasicFinancials(symbol: String)
}

protocol DetailedStockInteractorOutput: class {
    func didLoadNews(_ news: [News])
    func didLoadBasicFinancials(_ metric: Metric)
}

protocol DetailedStockRouterInput: class {
    func showNews(with url: String)
}
