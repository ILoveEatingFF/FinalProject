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

protocol FavoritesModuleOutput: class {
}

protocol FavoritesViewInput: class {
    func update(with viewModels: [StockCardViewModel])
    func updateFiltered(with viewModels: [StockCardViewModel])
}

protocol FavoritesViewOutput: class {
    func didLoadView()
    func willViewAppear()
    func onTapFavorite(with symbol: String)
    func filter(stonks: [StockCardViewModel], with searchText: String)
}

protocol FavoritesInteractorInput: class {
    func load()
    func reload()
    func deleteFavorite(with symbol: String)
}

protocol FavoritesInteractorOutput: class {
    func didLoad(with stonks: [StonkDTO])
}

protocol FavoritesRouterInput: class {
}
