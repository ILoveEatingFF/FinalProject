import Foundation
import Network

protocol AccessibilityServiceProtocol {
    var isNetworkAccessable: Bool { get }
    func addOnNetworkAvailableHandler(source: String, handler: @escaping () -> Void)
    func addOnNetworkUnAvailableHandler(source: String, handler: @escaping () -> Void)
}

final class AccessibilityService: AccessibilityServiceProtocol {
    private(set) var isNetworkAccessable: Bool = false
    private let queue = DispatchQueue(label: "com.network.accessibility.lizogub")
    
    private var onNetworkAvailableHandlers: [String: () -> Void] = [:]
    private var onNetworkUnAvailableHandlers: [String: () -> Void] = [:]
    
    private var monitor: NWPathMonitor = NWPathMonitor()
    
    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied {
                self.isNetworkAccessable = true
                self.onNetworkAvailableHandlers.values.forEach {
                    $0()
                }
            } else {
                self.isNetworkAccessable = false
                self.onNetworkUnAvailableHandlers.values.forEach {
                    $0()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func addOnNetworkAvailableHandler(source: String, handler: @escaping () -> Void) {
        queue.async {
            self.onNetworkAvailableHandlers[source] = handler
        }
    }
    
    func addOnNetworkUnAvailableHandler(source: String, handler: @escaping () -> Void) {
        queue.async {
            self.onNetworkUnAvailableHandlers[source] = handler
        }
    }
}
