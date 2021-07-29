import Foundation
import Security

public final class KeychainService {
    
    // MARK: - Properties
    
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // MARK: - Init
    init(encoder: JSONEncoder, decoder: JSONDecoder) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    convenience init() {
        self.init(encoder: JSONEncoder(), decoder: JSONDecoder())
    }
    
    // MARK: - Public
    func setValue<T: Codable>(_ value: T, queryItem: SecureStoreQueryable) throws {
        let valueData: Data
        do {
            valueData = try encoder.encode(value)
        } catch {
            throw SecureStoreError.encodingError
        }
        
        var query = queryItem.query
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = valueData
            
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = valueData
            status = SecItemAdd(query as CFDictionary, nil)
            
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }
    
    func getObject<T: Decodable>(queryItem: SecureStoreQueryable) throws -> T? {
        var query = queryItem.query
        
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let data = queriedItem[String(kSecValueData)] as? Data
                else {
                    throw self.error(from: status)
                }
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw SecureStoreError.decodingError
            }
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }
    
    func removeObject(userName: String, queryItem: SecureStoreQueryable) throws {
        var query = queryItem.query
        query[String(kSecAttrAccount)] = userName
        
        let status = SecItemDelete(query as CFDictionary)
        guard status != errSecSuccess || status != errSecItemNotFound else {
            throw error(from: status)
        }
    }
    
    func removeAll(queryItem: SecureStoreQueryable) throws {
        var query = queryItem.query
        query[String(kSecAttrAccount)] = nil
        
        let status = SecItemDelete(query as CFDictionary)
        guard status != errSecSuccess || status != errSecItemNotFound else {
            throw error(from: status)
        }
    }
}

// MARK: - Private

private extension KeychainService {
    func error(from status: OSStatus) -> SecureStoreError {
      let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
      return SecureStoreError.unhandledError(message: message)
    }
}
