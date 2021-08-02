//
//  FavoritesProtocols.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import Foundation

protocol FavoritesModuleInput {
	var moduleOutput: FavoritesModuleOutput? { get }
}

protocol FavoritesModuleOutput: AnyObject {
}

protocol FavoritesViewInput: AnyObject {
    func update(with viewModels: [StockCardViewModel])
    func updateFiltered(with viewModels: [StockCardViewModel])
}

protocol FavoritesViewOutput: AnyObject {
    func didLoadView()
    func willViewAppear()
    func onTapFavorite(with symbol: String)
    func onTapStock(_ stock: StockCardViewModel)
    func filter(stonks: [StockCardViewModel], with searchText: String)
}

protocol FavoritesInteractorInput: AnyObject {
    func load()
    func reload()
    func deleteFavorite(with symbol: String)
}

protocol FavoritesInteractorOutput: AnyObject {
    func didLoad(with stonks: [StonkDTO])
}

protocol FavoritesRouterInput: AnyObject {
    func showDetailedStock(_ stock: StockCardViewModel)
}
