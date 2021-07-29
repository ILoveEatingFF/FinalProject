import Foundation

enum SecureStoreError: Error {
    case encodingError
    case decodingError
    case unhandledError(message: String)
}

extension SecureStoreError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .encodingError:
            return NSLocalizedString("Object encoding error", comment: "")
        case .decodingError:
            return NSLocalizedString("Object decoding error", comment: "")
        case .unhandledError(let message):
          return NSLocalizedString(message, comment: "")
        }
    }
}
 
