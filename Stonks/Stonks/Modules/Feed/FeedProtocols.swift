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

protocol FeedModuleOutput: class {
}

protocol FeedViewInput: class {
    func update(with viewModels: [StockCardViewModel])
}

protocol FeedViewOutput: class {
    var hasNextPage: Bool { get }
    func didLoadView()
    func willViewAppear()
    func reload()
    func didSelectStock(_ stock: StockCardViewModel)
    func willDisplay(at index: Int, cellCount: Int)
    func didTapOnFavorite(symbol: String, isFavorite: Bool)
}

protocol FeedInteractorInput: class {
    func load(with index: MarketIndex)
    func loadNext()
    func reloadFavorites()
    func saveOrDeleteFavorite(symbol: String, isFavorite: Bool)
}

protocol FeedInteractorOutput: class {
    func didLoad(_ stonks: [StonkDTO], hasNextPage: Bool)
    func didLoadNextBatch(_ stonks: [StonkDTO], hasNextPage: Bool)
}

protocol FeedRouterInput: class {
    func showDetailedStock(_ stock: StockCardViewModel)
}
