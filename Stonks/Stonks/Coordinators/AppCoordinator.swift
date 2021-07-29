import UIKit

final class AppCoordinator: BaseCoordinator {
    weak var rootCoordinator: RootCoordinator?
    
    private let window: UIWindow?
    private let tabBarControllerBuilder: TabBarControllerBuilder
    private let serviceLocator: ServiceLocator
    
    init(
        window: UIWindow?,
        tabBarControllerBuilder: TabBarControllerBuilder,
        serviceLocator: ServiceLocator
    ) {
        self.window = window
        self.tabBarControllerBuilder = tabBarControllerBuilder
        self.serviceLocator = serviceLocator
        
        super.init()
    }
    
    override func start() {
        setup()
    }
    
    private func setup() {
        setupMain()
        setupFavorites()
        setupProfile()
        let tabBarController = tabBarControllerBuilder.makeTabBar()
        
        window?.rootViewController = tabBarController
    }
    
    private func setupMain() {
        let context = FeedContext(
            moduleOutput: nil,
            networkService: serviceLocator.stockNetworkService,
            imageLoader: serviceLocator.imageLoaderService,
            databaseService: serviceLocator.databaseService,
            defaultService: serviceLocator.userDefaultsService,
            accessibilityService: serviceLocator.accessibilityService
        )
        let container = FeedContainer.assemble(with: context)
        tabBarControllerBuilder.makeMain(with: [container.viewController])
    }
    
    private func setupFavorites() {
        let context = FavoritesContext(
            moduleOutput: nil,
            networkService: serviceLocator.stockNetworkService,
            databaseService: serviceLocator.databaseService,
            defaultsService: serviceLocator.userDefaultsService,
            accessibilityService: serviceLocator.accessibilityService,
            imageLoader: serviceLocator.imageLoaderService
        )
        let container = FavoritesContainer.assemble(with: context)
        tabBarControllerBuilder.makeFavorites(with: [container.viewController])
    }
    
    
    private func setupProfile() {
        let context = ProfileContext(
            moduleOutput: self,
            defaultsService: serviceLocator.userDefaultsService
        )
        let container = ProfileContainer.assemble(with: context)
        tabBarControllerBuilder.makeProfile(with: [container.viewController])
    }
}

extension AppCoordinator: ProfileModuleOutput {
    func didLogOut() {
        rootCoordinator?.auth()
    }
    
}
