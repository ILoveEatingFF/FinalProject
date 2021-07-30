import Foundation

final class NetworkService {
    private let session = URLSession(configuration: .default)
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    func baseRequest<T: Decodable>(url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NetworkServiceError.wrongURL))
            return
        }
        let request = URLRequest(url: url)
        
        let handler: Handler = { [weak self] rawData, response, taskError in
            guard let self = self else { return }
            if let error = taskError {
                completion(.failure(error))
                return
            }
            guard let data = rawData else {
                completion(.failure(NetworkServiceError.dataIsNil))
                return
            }
            do {
                let decodedObject = try self.decoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
        
        session.dataTask(with: request, completionHandler: handler).resume()
    }
}

extension NetworkService: StockNetworkServiceProtocol {
    func loadBasicFinancials(with symbol: String, completion: @escaping (Result<StonkMetrics, Error>) -> Void) {
        let url = URLFactory.basicFinancials(with: symbol)
        baseRequest(url: url, completion: completion)
    }
    
    func lookupSymbol(with text: String, completion: @escaping (Result<SymbolsLookup, Error>) -> Void) {
        let url = URLFactory.symbolsLookUp(text: text)
        baseRequest(url: url, completion: completion)
    }
    
    func loadNews(with symbol: String, startDate: Date, endDate: Date, completion: @escaping (Result<[News], Error>) -> Void) {
        let url = URLFactory.news(symbol: symbol, startDate: startDate, endDate: endDate)
        baseRequest(url: url, completion: completion)
    }
    
    
    func loadNews(with symbol: String, lastNews: Int, completion: @escaping (Result<[News], Error>) -> Void) {
        let url = URLFactory.news(symbol: symbol, last: lastNews)
        baseRequest(url: url, completion: completion)
    }
    
    func loadStonks(with symbols: [String], page: Int, completion: @escaping (Result<StonkResponse, Error>) -> Void) {
        guard page > 0 else {
            completion(.failure(NetworkServiceError.wrongPage))
            return
        }
        let pagedSymbolsSubarray = symbolsSubarrayBasedOnPage(symbols, page: page)
        let url = URLFactory.stonks(symbols: pagedSymbolsSubarray)
        baseRequest(url: url, completion: completion)
    }
    
    func loadImage(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        baseRequest(url: url, completion: completion)
    }
    
    func loadSymbols(with marketIndex: MarketIndex, completion: @escaping (Result<Symbols, Error>) -> Void) {
        let url = URLFactory.tickers(marketIndex: marketIndex)
        baseRequest(url: url, completion: completion)
    }
    
}

// MARK: - Private extension

private extension NetworkService {
    func symbolsSubarrayBasedOnPage(_ symbols: [String], page: Int) -> [String] {
        guard page > 0 else {
            return []
        }
        let startIndexOffest = (page - 1) * Constants.indexPageMultiplier
        let endIndexOffest = page * Constants.indexPageMultiplier
        if symbols.count < startIndexOffest {
            return []
        } else if symbols.count >= startIndexOffest && symbols.count < endIndexOffest {
            return Array(symbols[startIndexOffest..<symbols.endIndex])
        } else {
            return Array(symbols[startIndexOffest..<endIndexOffest])
        }
    }
}

// MARK: - Nested Types

extension NetworkService {
    enum NetworkServiceError: Error {
        case wrongURL
        case decodable
        case dataIsNil
        case unknown
        case wrongPage
    }
    
    private enum Constants {
        static let indexPageMultiplier = 100
    }
}

