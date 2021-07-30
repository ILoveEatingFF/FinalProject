//
//  FeedInteractor.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import Foundation

final class FeedInteractor {
    weak var output: FeedInteractorOutput?
    
    private let networkService: StockNetworkServiceProtocol
    private let databaseService: DatabaseServiceProtocol
    private let defaultService: StorageServiceProtocol
    private let accessibilityService: AccessibilityServiceProtocol
    
    private var companySymbols: [String] = []
    private var companyStonks: [StonkDTO] = []
    
    private var searchCompanySymbols: [String] = []
    private var searchCompanyStonks: [StonkDTO] = []
    
    private let stockQueue = DispatchQueue(label: "com.queue.stock.lizogub", qos: .userInteractive, attributes: .concurrent)
    
    private var page = Constants.initialPage
    
    private lazy var currentUser: String = {
        guard let user = defaultService.currentUser else {
            assertionFailure("User should not be nil in app")
            return ""
        }
        return user
    }()
    
    private var currentFundIndex: MarketIndex = .sp500
    
    private var dataWasLoadedFromServer: Bool = false
    
    init(
        networkService: StockNetworkServiceProtocol,
        databaseService: DatabaseServiceProtocol,
        defaultService: StorageServiceProtocol,
        accessibilityService: AccessibilityServiceProtocol
    ) {
        self.networkService = networkService
        self.databaseService = databaseService
        self.defaultService = defaultService
        self.accessibilityService = accessibilityService
    }
}

extension FeedInteractor: FeedInteractorInput {
    func loadStonks(with searchText: String) {
        let group = DispatchGroup()
        
        group.enter()
        networkService.lookupSymbol(with: searchText) { result in
            switch result {
            case .success(let symbolResponse):
                let result = symbolResponse.result.map {
                    $0.symbol
                }
                self.searchSymbols = result
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.networkService.loadStonks(with: self.searchSymbols, page: 1) { result in
                switch result {
                case .success(let stonkResponse):
                    self.searchStocks = self.updateStonksFavorite(stonks: stonkResponse.stonks)
                    self.databaseService.update(stonks: stonkResponse.stonks, marketIndex: nil)
                    DispatchQueue.main.async {
                        self.output?.didLoadSearch(self.searchStocks)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.output?.didEncounterError(error)
                    }
                }
            }
        }
    }
    
    func reloadFavorites() {
        self.stocks = updateStonksFavorite(stonks: self.stocks)
        self.searchStocks = updateStonksFavorite(stonks: self.searchStocks)
        let hasNextPage = self.stocks.count < self.symbols.count
        DispatchQueue.main.async {
            self.output?.didLoad(self.stocks, hasNextPage: hasNextPage)
            self.output?.didLoadSearch(self.searchStocks)
        }
    }
    
    func loadNext() {
        networkService.loadStonks(with: symbols, page: page) { result in
            switch result {
            case .success(let response):
                self.addPage()
                self.stocks = self.updateStonks(with: response.stonks)
                let hasNextPage = self.stocks.count < self.symbols.count
                
                DispatchQueue.main.async {
                    self.output?.didLoad(self.stocks, hasNextPage: hasNextPage)
                    self.databaseService.update(stonks: self.stocks, marketIndex: self.currentFundIndex)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.output?.didEncounterError(error)
                }
            }
        }
    }
    
    func load(with index: MarketIndex = .sp500) {
        self.currentFundIndex = index
        if accessibilityService.isNetworkAccessable {
            networkLoad(with: index)
        } else {
            offlineLoad(with: index)
//             TODO: Добавить функционал, чтобы все данные, которые отображены обновились с
//            сервера(часть необходимого функционала написал)
            accessibilityService.addOnNetworkAvailableHandler(source: FeedInteractor.identifier) { [weak self] in
                guard
                    let self = self,
                    !self.dataWasLoadedFromServer
                else { return }
                self.networkLoad(with: self.currentFundIndex)
            }
        }
    }
    
    func saveOrDeleteFavorite(symbol: String, isFavorite: Bool) {
        databaseService.saveUserFavorite(username: currentUser, symbol: symbol, isFavorite: isFavorite)
    }
    
    private func networkLoad(with index: MarketIndex) {
        let group = DispatchGroup()
        
        group.enter()
        networkService.loadSymbols(with: index) { result in
            switch result {
            case .success(let symbols):
                self.symbols = symbols.constituents
                self.stocks = []
                self.databaseService.updateIndexSymbols(index: self.currentFundIndex, symbols: symbols.constituents)
            case .failure:
                self.symbols = self.databaseService.getIndexSymbols(index: self.currentFundIndex)
            }
            group.leave()
        }
        
//         Метод может проваливаться в ошибку даже при хорошей сети,
//        так как в iex cloud api могли закончиться кредиты на запросы
//        в таком случае лучше заменить iex api key в URLFactory
        group.notify(queue: .main) {
            self.networkService.loadStonks(with: self.symbols, page: self.page) { result in
                switch result {
                case .success(let stonkResponse):
                    self.addPage()
                    self.stocks = self.updateStonks(with: stonkResponse.stonks)
                    let hasNextPage = self.stocks.count < self.symbols.count
                    DispatchQueue.main.async {
                        self.output?.didLoad(self.stocks, hasNextPage: hasNextPage)
                        self.dataWasLoadedFromServer = true
                        self.databaseService.update(stonks: self.stocks, marketIndex: self.currentFundIndex)
                    }
                case .failure:
                    self.offlineLoad(with: self.currentFundIndex)
                }
            }
        }
    }
    
    private func offlineLoad(with index: MarketIndex) {
        self.symbols = databaseService.getIndexSymbols(index: index)
        let savedStonks = databaseService.getStonks(with: symbols)
        self.stocks = updateStonks(with: savedStonks)
        DispatchQueue.main.async {
            self.output?.didLoad(self.stocks, hasNextPage: false)
        }
    }
}

// MARK: - Nested Types

private extension FeedInteractor {
    enum Constants {
        static let initialPage = 1
    }
    
    var stocks: [StonkDTO] {
        get {
            stockQueue.sync {
                return self.companyStonks
            }
        }
        set {
            stockQueue.async(flags: .barrier) {
                self.companyStonks = newValue
            }
        }
    }
    
    var symbols: [String] {
        get {
            stockQueue.sync {
                return self.searchCompanySymbols
            }
        }
        set {
            stockQueue.async(flags: .barrier) {
                self.searchCompanySymbols = newValue
            }
        }
    }
    
    var searchSymbols: [String] {
        get {
            stockQueue.sync {
                return self.companySymbols
            }
        }
        set {
            stockQueue.async(flags: .barrier) {
                self.companySymbols = newValue
            }
        }
    }
    
    var searchStocks: [StonkDTO] {
        get {
            stockQueue.sync {
                return self.searchCompanyStonks
            }
        }
        set {
            stockQueue.async(flags: .barrier) {
                self.searchCompanyStonks = newValue
            }
        }
    }
    
    private func addStonks(stonks: [StonkDTO]) {
        stockQueue.async(flags: .barrier) {
            self.companyStonks.append(contentsOf: stonks)
        }
    }
    
    private func addPage() {
        stockQueue.async(flags: .barrier) {
            self.page += 1
        }
    }
    
    private func updateStonks(with newBatch: [StonkDTO]) -> [StonkDTO] {
        let allStonks = sumStonksAndUpdateIfIntersected(oldBatch: self.stocks, newBatch: newBatch)
        let result: [StonkDTO] = updateStonksFavorite(stonks: allStonks)
        
        return result
    }
    
    private func updateStonksFavorite(stonks: [StonkDTO]) -> [StonkDTO] {
        let favoriteStonksSymbols = Set<String>(self.databaseService.getFavoritesSymbols(username: self.currentUser))
        let result: [StonkDTO] = stonks.map {
            StonkDTO(
                symbol: $0.symbol,
                quote: $0.quote,
                logo: $0.logo,
                isFavorite: favoriteStonksSymbols.contains($0.symbol ?? "") ? true : false
            )
        }
        
        return result
    }
    
    // Если в в новой пачке встречаются те же символы, что и в старой, то обновляем инфу. Иначе закидываем в конец
    private func sumStonksAndUpdateIfIntersected(oldBatch: [StonkDTO], newBatch: [StonkDTO]) -> [StonkDTO] {
        var result: [StonkDTO] = []
        let newBatchStocksDict: [String: StonkDTO] = newBatch.reduce(into: [String: StonkDTO]()) {
            (dict, stonk) in
            dict[stonk.symbol ?? ""] = stonk
        }
        
        var intersectedSymbols = Set<String>()
        let updatedOldBatch: [StonkDTO] = oldBatch.map {
            let stonkDTO: StonkDTO
            if let newBatchStonk = newBatchStocksDict[$0.symbol ?? ""] {
                stonkDTO = StonkDTO(
                    symbol: newBatchStonk.symbol,
                    quote: newBatchStonk.quote,
                    logo: newBatchStonk.logo,
                    isFavorite: $0.isFavorite
                )
                intersectedSymbols.insert(newBatchStonk.symbol ?? "")
            } else {
                stonkDTO = StonkDTO(
                    symbol: $0.symbol,
                    quote: $0.quote,
                    logo: $0.logo,
                    isFavorite: $0.isFavorite
                )
            }
            
            return stonkDTO
        }
        
        let filteredNewBatch: [StonkDTO] = newBatch.filter {
            !intersectedSymbols.contains($0.symbol ?? "")
        }
        
        result = updatedOldBatch + filteredNewBatch
        
        return result
    }
    
}

extension FeedInteractor: UniqueIdentifier {}
