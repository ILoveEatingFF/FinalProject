import UIKit

class BaseRouter {
    var navigationControllerProvider: (() -> UINavigationController?)?
    
    var navigationController: UINavigationController? {
        navigationControllerProvider?()
    }
}
