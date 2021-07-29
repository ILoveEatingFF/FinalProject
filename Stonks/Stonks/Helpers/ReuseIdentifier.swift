import UIKit

protocol ReuseIdentifiable {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReuseIdentifiable {}
