import UIKit

final class RootCoordinator: BaseCoordinator {
    private let window: UIWindow?
    private let appCoordinator: AppCoordinator
    private let authCoordinator: AuthCoordinator
    
    private let serviceLocator: ServiceLocator
    
    init(
        window: UIWindow?,
        appCoordinator: AppCoordinator,
        authCoordinator: AuthCoordinator,
        serviceLocator: ServiceLocator
    ) {
        self.window = window
        self.appCoordinator = appCoordinator
        self.authCoordinator = authCoordinator
        self.serviceLocator = serviceLocator
        
        super.init()
    }
    
    convenience init(window: UIWindow?) {
        let tabBarControllerBuilder = TabBarControllerBuilder()
        let serviceLocator = ServiceLocator()
        
        let appCoordinator = AppCoordinator(
            window: window,
            tabBarControllerBuilder: tabBarControllerBuilder,
            serviceLocator: serviceLocator
        )
        
        let authCoordinator = AuthCoordinator(window: window, serviceLocator: serviceLocator)
        
        self.init(
            window: window,
            appCoordinator: appCoordinator,
            authCoordinator: authCoordinator,
            serviceLocator: serviceLocator
        )
        
        appCoordinator.rootCoordinator = self
        authCoordinator.rootCoordinator = self
    }
    
    override func start() {
        auth()
    }
    
    func auth() {
        if let username: String = serviceLocator.userDefaultsService.get(for: DefaultsConstants.currentUserKey),
           let _: String = try? serviceLocator.keychainService.getObject(
            queryItem: GenericPassword(key: KeychainConstants.genericPasswordService, username: username)
           ),
           !CommandLine.arguments.contains(LaunchArgumentsConstants.isUITesting)
        {
            autologin()
        } else {
            authCoordinator.start()
        }
    }
    
    func autologin() {
        appCoordinator.start()
    }
    
    func startApp() {
        appCoordinator.start()
    }
}
