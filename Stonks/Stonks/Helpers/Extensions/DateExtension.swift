import Foundation

extension Date {
    var millisecondsSince1970:TimeInterval {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }

    init(milliseconds:TimeInterval) {
        self = Date(timeIntervalSince1970: milliseconds / 1000)
    }
}
