import Foundation

final class DetailedStockInteractor {
	weak var output: DetailedStockInteractorOutput?
    
    private let databaseService: DatabaseServiceProtocol
    private let defaultsService: StorageServiceProtocol
    private let networkService: StockNetworkServiceProtocol
    private let accessibilityService: AccessibilityServiceProtocol
    
    private lazy var currentUser: String = {
        guard let user = defaultsService.currentUser else {
            assertionFailure("User should not be nil in app")
            return ""
        }
        return user
    }()
    
    init(
        databaseService: DatabaseServiceProtocol,
        defaultsService: StorageServiceProtocol,
        networkService: StockNetworkServiceProtocol,
        accessibilityService: AccessibilityServiceProtocol
         ) {
        self.databaseService = databaseService
        self.defaultsService = defaultsService
        self.networkService = networkService
        self.accessibilityService = accessibilityService
    }
    
}

extension DetailedStockInteractor: DetailedStockInteractorInput {
    func loadBasicFinancials(symbol: String) {
        networkService.loadBasicFinancials(with: symbol) { result in
            switch result {
            case .success(let metricResponse):
                DispatchQueue.main.async {
                    self.output?.didLoadBasicFinancials(metricResponse.metric)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadNews(symbol: String, lastNews: Int = 50) {
        networkService.loadNews(with: symbol, lastNews: lastNews) { result in
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    self.output?.didLoadNews(news)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func isStockFavorite(with symbol: String) -> Bool {
        var result = false
        let favoriteStonks = databaseService.getFavorites(username: currentUser)
        favoriteStonks.forEach {
            if $0.symbol == symbol {
                result = true
            }
        }
        
        return result
    }
    
    func saveOrDeleteFavorite(symbol: String, isFavorite: Bool) {
        databaseService.saveUserFavorite(username: currentUser, symbol: symbol, isFavorite: isFavorite)
    }
    
}
