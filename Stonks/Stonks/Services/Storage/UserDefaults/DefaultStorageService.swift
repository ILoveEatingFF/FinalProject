import Foundation

final class DefaultStorageService: StorageServiceProtocol {
    var currentUser: String? {
        let user: String? = self.get(for: DefaultsConstants.currentUserKey)
        return user
    }
    
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    convenience init() {
        self.init(defaults: UserDefaults.standard)
    }
    
    func save<T: Encodable>(object: T, for key: String) {
        guard let data = try? encoder.encode(object) else {
            return
        }
        defaults.setValue(data, forKey: key)
    }
    
    func get<T: Decodable>(for key: String) -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        
        return try? decoder.decode(T.self, from: data)
    }
}
