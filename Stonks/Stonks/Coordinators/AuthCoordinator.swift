import UIKit

final class AuthCoordinator: BaseCoordinator {
    
    weak var rootCoordinator: RootCoordinator?
    
    private let window: UIWindow?
    
    private weak var router: LoginRouterInput?
    private let serviceLocator: ServiceLocator
    
    private weak var loginInput: LoginModuleInput?
    
    init(window: UIWindow?, serviceLocator: ServiceLocator) {
        self.window = window
        self.serviceLocator = serviceLocator
        super.init()
    }
    
    override func start() {
        setup()
    }
    
    func setup() {
        let context = LoginContext(
            moduleOutput: self,
            keychainService: serviceLocator.keychainService,
            defaultsService: serviceLocator.userDefaultsService
        )
        let container = LoginContainer.assemble(with: context)
        let navVC = UINavigationController(rootViewController: container.viewController)
        window?.rootViewController = navVC
        
        router = container.router
        loginInput = container.input
    }
}

extension AuthCoordinator: LoginModuleOutput {
    func startApp() {
        rootCoordinator?.startApp()
    }
    
    func showSignUp() {
        let context = SignUpContext(
            moduleOutput: self,
            keychainService: serviceLocator.keychainService,
            databaseService: serviceLocator.databaseService
        )
        let container = SignUpContainer.assemble(with: context)
        
        router?.push(container.viewController, animated: true)
    }
}

extension AuthCoordinator: SignUpModuleOutput {
    func didSignUp(username: String, password: String) {
        loginInput?.didSignUp(username: username, password: password)
        router?.popToRootVC(animated: true)
    }
    
}
