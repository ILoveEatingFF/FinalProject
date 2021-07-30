import Foundation

enum URLFactory {
    private static let finnhubKey = "c1avt0748v6rcdq9sv6g"
    private static let finnhubParams = ApiParams(scheme: "https", host: "finnhub.io", apiKeyName: "token")
    
    private static let iexKey = "pk_f2e614e8d8e140e6b4ef1387f7ff86bf"
//    private static let iexKey = "pk_5460816a0c934baf999a677499c3c309"
    private static let iexParams = ApiParams(scheme: "https", host: "cloud.iexapis.com", apiKeyName: "token")
    
    private static let iexSandboxKey = "Tpk_7f07bda7bbd2468ea3ac6c241173e45f"
    private static let iexSandboxParams = ApiParams(scheme: "https", host: "sandbox.iexapis.com", apiKeyName: "token")

    private static func buildBaseComponents(ofType type: ApiType) -> URLComponents {
        var result = URLComponents()
        var params: ApiParams?
        var key = ""
        switch type {
        case .finnhub:
            key = finnhubKey
            params = finnhubParams
        case .iex:
            key = iexKey
            params = iexParams
        case .iexSandbox:
            key = iexSandboxKey
            params = iexSandboxParams
        }
        result.scheme = params?.scheme
        result.host = params?.host
        let queryItem = URLQueryItem(name: params?.apiKeyName ?? "api_key", value: key)
        result.queryItems = [queryItem]
        return result
    }
    
    static func stonks(symbols: [String]) -> URL? {
        var baseComp = buildBaseComponents(ofType: .iex)
        baseComp.path = "/stable/stock/market/batch"
        let params = [
            URLQueryItem(name: "symbols", value: symbols.joined(separator: ",")),
            URLQueryItem(name: "types", value: "quote,logo")]
        baseComp.queryItems?.append(contentsOf: params)
        
        return baseComp.url
    }

    static func tickers(marketIndex: MarketIndex) -> URL? {
        var baseComp = buildBaseComponents(ofType: .finnhub)
        baseComp.path = "/api/v1/index/constituents"
        let params = [URLQueryItem(name: "symbol", value: marketIndex.rawValue)]
        baseComp.queryItems?.append(contentsOf: params)
        return baseComp.url
    }
    
    static func news(symbol: String, last: Int) -> URL? {
        var baseComp = buildBaseComponents(ofType: .iex)
        baseComp.path = "/stable/stock/\(symbol)/news/last/\(last)"
        
        return baseComp.url
    }
    
    static func news(symbol: String, startDate: Date, endDate: Date) -> URL? {
        var baseComp = buildBaseComponents(ofType: .finnhub)
        baseComp.path = "/company-news"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let params = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "from", value: dateFormatter.string(from: startDate)),
            URLQueryItem(name: "to", value: dateFormatter.string(from: endDate))
        ]
        baseComp.queryItems?.append(contentsOf: params)
        return baseComp.url
    }
    
    static func symbolsLookUp(text: String) -> URL? {
        var baseComp = buildBaseComponents(ofType: .finnhub)
        baseComp.path = "/api/v1/search"
        let params = [URLQueryItem(name: "q", value: text)]
        baseComp.queryItems?.append(contentsOf: params)
        return baseComp.url
    }
    
    static func basicFinancials(with symbol: String) -> URL? {
        var baseComp = buildBaseComponents(ofType: .finnhub)
        baseComp.path = "/api/v1//stock/metric"
        let params = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "metric", value: "all")
        ]
        baseComp.queryItems?.append(contentsOf: params)
        return baseComp.url
    }
}


// MARK: - Nested Types

private extension URLFactory {
    enum StonkPart: String {
        case general = "stock/profile2"
        case price = "quote"
    }
}
