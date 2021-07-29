import Foundation

protocol UniqueIdentifier {
    static var identifier: String { get }
}

extension UniqueIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
