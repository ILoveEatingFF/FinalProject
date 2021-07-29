import UIKit

final class TabBarControllerBuilder {
    private let tabBarController = UITabBarController()
    private lazy var navigationControllers: [NavControllerType: UINavigationController] = [:]
    
    func makeTabBar() -> UITabBarController {
        setupAppearance()
        let navControllers = NavControllerType.allCases.compactMap {
            navigationControllers[$0]
        }
        tabBarController.setViewControllers(navControllers, animated: false)
        
        return tabBarController
    }
    
    func makeDefaultTabBar(
        mainViewControllers: [UIViewController] = [],
        favoritesViewControllers: [UIViewController] = [],
        profileViewControllers: [UIViewController] = []
    ) -> UITabBarController {
        clean()
        setupAppearance()
        makeMain(with: mainViewControllers)
        makeFavorites(with: favoritesViewControllers)
        makeProfile(with: profileViewControllers)
        
        let navControllers = NavControllerType.allCases.compactMap {
            navigationControllers[$0]
        }
        
        tabBarController.setViewControllers(navControllers, animated: false)
        
        return tabBarController
    }
    
    func clean() {
        navigationControllers = [:]
    }
    
    func makeMain(with viewControllers: [UIViewController] = []) {
        navigationControllers[.main] = buildNavController(of: .main, viewControllers: viewControllers)
    }
    
    func makeFavorites(with viewControllers: [UIViewController] = []) {
        navigationControllers[.favorites] = buildNavController(of: .favorites, viewControllers: viewControllers)
    }
    
    func makeProfile(with viewControllers: [UIViewController] = []) {
        navigationControllers[.profile] = buildNavController(of: .profile, viewControllers: viewControllers)
    }
    
    private func setupAppearance() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = Color.lightBlack
    }
    
    private func buildNavController(of type: NavControllerType, viewControllers: [UIViewController] = []) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setViewControllers(viewControllers, animated: false)
        let tabBarItem = UITabBarItem(
            title: type.title,
            image: type.image,
            selectedImage: type.selectedImage
        )
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }
    
}

extension TabBarControllerBuilder {
    enum NavControllerType: CaseIterable {
        case main
        case favorites
        case profile
        
        var title: String {
            switch self {
            case .main:
                return Constants.main
            case .favorites:
                return Constants.favorites
            case .profile:
                return Constants.profile
            }
        }
        
        var image: UIImage? {
            switch self {
            case .main:
                return UIImage(systemName: "house")
            case .favorites:
                return UIImage(systemName: "star")
            case .profile:
                return UIImage(systemName: "person")
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .main:
                return UIImage(systemName: "house.fill")
            case .favorites:
                return UIImage(systemName: "star.fill")
            case .profile:
                return UIImage(systemName: "person.fill")
            }
        }
    }
}

private extension TabBarControllerBuilder {
    enum Constants {
        static let main = "Главная"
        static let favorites = "Избранное"
        static let profile = "Профиль"
    }
}
