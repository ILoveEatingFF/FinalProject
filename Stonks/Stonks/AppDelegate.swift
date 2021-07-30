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
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        rootCoordinator = RootCoordinator(window: window)
        rootCoordinator?.start()
        
        return true
    }

}

