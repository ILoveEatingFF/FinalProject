import Foundation

extension Date {
    var millisecondsSince1970:TimeInterval {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }

    init(milliseconds:TimeInterval) {
        self = Date(timeIntervalSince1970: milliseconds / 1000)
    }
}

extension Date {
    var weekAgo: Date {
        let timeInterval = self.timeIntervalSince1970.weekBeforeInterval
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    var monthAgo: Date {
        let timeInterval = self.timeIntervalSince1970.monthBeforeInterval
        return Date(timeIntervalSince1970: timeInterval)
    }
}

extension TimeInterval {
    var dayBeforeInterval: TimeInterval {
        return self - (24 * 60 * 60)
    }
    
    var weekBeforeInterval: TimeInterval {
        return self - (24 * 60 * 60 * 7)
    }
    
    var monthBeforeInterval: TimeInterval {
        return self - (24 * 60 * 60 * 30)
    }
}
