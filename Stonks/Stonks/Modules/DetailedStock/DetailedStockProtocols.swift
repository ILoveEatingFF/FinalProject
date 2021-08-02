import Foundation

protocol DetailedStockModuleInput {
	var moduleOutput: DetailedStockModuleOutput? { get }
}

protocol DetailedStockModuleOutput: AnyObject {
}

protocol DetailedStockViewInput: AnyObject {
    func updateFavorite(isFavorite: Bool)
    func updateNews(with viewModels: [NewsViewModel])
    func updateBasicFinancials(with viewModel: BasicFinancialsViewModel)
}

protocol DetailedStockViewOutput: AnyObject {
    func didTapOnFavorite(symbol: String, isFavorite: Bool)
    func didTapBasicFinancials(symbol: String)
    func didTapNewsSegment(symbol: String)
    func didTapNewsItem(_ url: String)
}

protocol DetailedStockInteractorInput: AnyObject {
    func saveOrDeleteFavorite(symbol: String, isFavorite: Bool)
    func isStockFavorite(with symbol: String) -> Bool
    func loadNews(symbol: String, lastNews: Int)
    func loadNews(symbol: String, startDate: Date, endDate: Date)
    func loadBasicFinancials(symbol: String)
}

protocol DetailedStockInteractorOutput: AnyObject {
    func didLoadNews(_ news: [News])
    func didLoadBasicFinancials(_ metric: Metric)
}

protocol DetailedStockRouterInput: AnyObject {
    func showNews(with url: String)
}
