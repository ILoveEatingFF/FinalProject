import Foundation

protocol StockNetworkServiceProtocol {
    func loadSymbols(with marketIndex: MarketIndex, completion: @escaping (Result<Symbols, Error>) -> Void)
    func loadImage(url: URL?, completion: @escaping (Result<Data, Error>) -> Void)
    func loadStonks(with symbols: [String], page: Int, completion: @escaping (Result<StonkResponse, Error>) -> Void)
    func loadNews(with symbol: String, lastNews: Int, completion: @escaping (Result<[News], Error>) -> Void)
    func loadNews(with symbol: String, startDate: Date, endDate: Date, completion: @escaping (Result<[News], Error>) -> Void)
    func lookupSymbol(with text: String, completion: @escaping (Result<SymbolsLookup, Error>) -> Void)
}

struct ApiParams {
    let scheme: String
    let host: String
    let apiKeyName: String
}

enum ApiType {
    case iex
    case iexSandbox
    case finnhub
}
