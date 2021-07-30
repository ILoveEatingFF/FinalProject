import Foundation

struct StonkMetrics: Codable {
    let metric: Metric
}

struct Metric: Codable {
    let tenDayAverageTradingVolume: Double?
    let weekHigh52: Double?
    let weekLow52: Double?
    let weekPriceReturnDaily52: Double?
    let marketCapitalization: Double?
    let beta: Double?
    
    enum CodingKeys: String, CodingKey {
        case tenDayAverageTradingVolume = "10DayAverageTradingVolume"
        case weekHigh52 = "52WeekHigh"
        case weekLow52 = "52WeekLow"
        case weekPriceReturnDaily52 = "52WeekPriceReturnDaily"
        
        case marketCapitalization
        case beta
    }
}
