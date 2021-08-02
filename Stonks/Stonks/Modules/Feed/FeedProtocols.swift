//
//  FeedProtocols.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import Foundation

protocol FeedModuleInput {
	var moduleOutput: FeedModuleOutput? { get }
}

protocol FeedModuleOutput: AnyObject {
}

protocol FeedViewInput: AnyObject {
    func update(with viewModels: [StockCardViewModel])
    func updateSearch(with viewModels: [StockCardViewModel])
}

protocol FeedViewOutput: AnyObject {
    var hasNextPage: Bool { get }
    func didLoadView()
    func willViewAppear()
    func didSelectStock(_ stock: StockCardViewModel)
    func willDisplay(at index: Int, cellCount: Int, isSearched: Bool)
    func didTapOnFavorite(symbol: String, isFavorite: Bool)
    func searchSymbols(_ searchText: String)
}

protocol FeedInteractorInput: AnyObject {
    func load(with index: MarketIndex)
    func loadNext()
    func reloadFavorites()
    func saveOrDeleteFavorite(symbol: String, isFavorite: Bool)
    func loadStonks(with searchText: String)
}

protocol FeedInteractorOutput: AnyObject {
    func didLoad(_ stonks: [StonkDTO], hasNextPage: Bool)
    func didLoadSearch(_ stonks: [StonkDTO])
    func didEncounterError(_ error: Error)
}

protocol FeedRouterInput: AnyObject {
    func showDetailedStock(_ stock: StockCardViewModel)
}
