import Foundation

public protocol SecureStoreQueryable {
    var query: [String: Any] { get }
}

public struct GenericPassword {
    let key: String
    let username: String
}

extension GenericPassword: SecureStoreQueryable {
    public var query: [String : Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrAccount)] = username
        query[String(kSecAttrService)] = key
        query[String(kSecAttrAccessible)] = kSecAttrAccessibleAfterFirstUnlock
        
        return query
    }
}
