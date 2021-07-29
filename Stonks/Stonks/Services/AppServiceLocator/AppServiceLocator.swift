import Foundation

protocol HasUserDefaultsService {
    var userDefaultsService: StorageServiceProtocol { get }
}

protocol HasKeychainService {
    var keychainService: KeychainService { get }
}

protocol AppServiceLocatorDependencies: HasUserDefaultsService, HasKeychainService {}

class ServiceLocator: AppServiceLocatorDependencies {
    var userDefaultsService: StorageServiceProtocol = DefaultStorageService()
    var keychainService = KeychainService()
    lazy var stockNetworkService: StockNetworkServiceProtocol = NetworkService()
    lazy var imageLoaderService: ImageLoaderProtocol = ImageLoader()
    lazy var databaseService: DatabaseServiceProtocol = DatabaseService(coreDataStack: CoreDataStack.shared)
    lazy var accessibilityService: AccessibilityServiceProtocol = {
        let service = AccessibilityService()
        service.start()
        return service
    }()
}
