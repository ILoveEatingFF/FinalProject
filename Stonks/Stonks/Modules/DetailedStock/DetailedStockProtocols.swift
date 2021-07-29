import Foundation

protocol DetailedStockModuleInput {
	var moduleOutput: DetailedStockModuleOutput? { get }
}

protocol DetailedStockModuleOutput: class {
}

protocol DetailedStockViewInput: class {
    func updateFavorite(isFavorite: Bool)
    func updateNews(with viewModels: [NewsViewModel])
}

protocol DetailedStockViewOutput: class {
    func didTapOnFavorite(symbol: String, isFavorite: Bool)
    func didTapNews(symbol: String)
}

protocol DetailedStockInteractorInput: class {
    func saveOrDeleteFavorite(symbol: String, isFavorite: Bool)
    func isStockFavorite(with symbol: String) -> Bool
    func loadNews(symbol: String, lastNews: Int)
}

protocol DetailedStockInteractorOutput: class {
    func didLoadNews(_ news: [News])
}

protocol DetailedStockRouterInput: class {
}
