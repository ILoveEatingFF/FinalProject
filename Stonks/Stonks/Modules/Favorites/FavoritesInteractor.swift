//
//  FavoritesInteractor.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import Foundation

final class FavoritesInteractor {
	weak var output: FavoritesInteractorOutput?
    
    private let networkService: StockNetworkServiceProtocol
    private let databaseService: DatabaseServiceProtocol
    private let defaultsService: StorageServiceProtocol
    private let accessibilityService: AccessibilityServiceProtocol
    
    private lazy var currentUser: String = {
        guard let user = defaultsService.currentUser else {
            assertionFailure("User should not be nil in app")
            return ""
        }
        return user
    }()
    
    private var dataWasLoadedFromServer: Bool = false
    
    init(
        networkService: StockNetworkServiceProtocol,
        databaseService: DatabaseServiceProtocol,
        defaultsService: StorageServiceProtocol,
        accessibilityService: AccessibilityServiceProtocol
    ) {
        self.networkService = networkService
        self.databaseService = databaseService
        self.defaultsService = defaultsService
        self.accessibilityService = accessibilityService
    }
}

extension FavoritesInteractor: FavoritesInteractorInput {
    func reload() {
        load()
    }
    
    
    func load() {
        if accessibilityService.isNetworkAccessable {
            networkLoad()
        } else {
            offlineLoad()
            accessibilityService.addOnNetworkAvailableHandler(source: FavoritesInteractor.identifier) { [weak self] in
                guard
                    let self = self,
                    !self.dataWasLoadedFromServer
                else { return }
                
                self.networkLoad()
            }
        }
    }
    
    func deleteFavorite(with symbol: String) {
        databaseService.saveUserFavorite(username: currentUser, symbol: symbol, isFavorite: false)
    }
    
    private func networkLoad() {
        let favoriteSymbols = databaseService.getFavoritesSymbols(username: currentUser)
        
        networkService.loadStonks(with: favoriteSymbols, page: 1) { result in
            switch result {
            case .success(let response):
                self.databaseService.update(stonks: response.stonks, marketIndex: nil)
                let favoriteStonks = response.stonks.map {
                    StonkDTO(
                        symbol: $0.symbol,
                        quote: $0.quote,
                        logo: $0.logo,
                        isFavorite: true
                    )
                }
                DispatchQueue.main.async {
                    self.dataWasLoadedFromServer = true
                    self.output?.didLoad(with: favoriteStonks)
                }
            case .failure:
                self.offlineLoad()
            }
        }
    }
    
    private func offlineLoad() {
        let favoriteStonks = databaseService.getFavorites(username: currentUser)
        DispatchQueue.main.async {
            self.output?.didLoad(with: favoriteStonks)
        }
        
    }
}

extension FavoritesInteractor: UniqueIdentifier {}
