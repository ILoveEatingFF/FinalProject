//
//  AppDelegate.swift
//  Stonks
//
//  Created by Иван Лизогуб on 15.07.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootCoordinator: RootCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let databaseService = DatabaseService(coreDataStack: CoreDataStack.shared)
//        let stonks: [StonkDTO] = [
//            StonkDTO(symbol: "S", quote: Quote(symbol: "s", companyName: "s", latestPrice: 2, change: 3), logo: Logo(url: ""), isFavorite: true),
//            StonkDTO(symbol: "A", quote: Quote(symbol: "A", companyName: "s", latestPrice: 2, change: 2), logo: Logo(url: ""), isFavorite: true),
//            StonkDTO(symbol: "B", quote: Quote(symbol: "b", companyName: "s", latestPrice: 2, change: 2), logo: Logo(url: ""), isFavorite: true),
//            StonkDTO(symbol: "C", quote: Quote(symbol: "c", companyName: "s", latestPrice: 2, change: 2), logo: Logo(url: ""), isFavorite: true),
//            StonkDTO(symbol: "D", quote: Quote(symbol: "d", companyName: "s", latestPrice: 2, change: 2), logo: Logo(url: ""), isFavorite: true),
//            StonkDTO(symbol: "E", quote: Quote(symbol: "e", companyName: "s", latestPrice: 2, change: 2), logo: Logo(url: ""), isFavorite: true),
//            StonkDTO(symbol: "F", quote: Quote(symbol: "f", companyName: "s", latestPrice: 2, change: 2), logo: Logo(url: ""), isFavorite: true),
//            StonkDTO(symbol: "G", quote: Quote(symbol: "g", companyName: "s", latestPrice: 2, change: 2), logo: Logo(url: ""), isFavorite: true),
//        ]
//        databaseService.update(stonks: stonks)
//        print(databaseService.stonks(with: nil))
//        databaseService.delete(stonks: databaseService.stonks(with: nil))
//        print(databaseService.stonks(with: nil))
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        rootCoordinator = RootCoordinator(window: window)
        rootCoordinator?.start()
        
        return true
    }

}

