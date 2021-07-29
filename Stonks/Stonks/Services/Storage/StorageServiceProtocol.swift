import Foundation

protocol StorageServiceProtocol: class {
    var currentUser: String? { get }
    func save<T: Encodable>(object: T, for key: String)
    func get<T: Decodable>(for key: String) -> T?
}
