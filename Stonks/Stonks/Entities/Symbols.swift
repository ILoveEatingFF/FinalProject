import Foundation

// for FundIndex
struct Symbols: Codable {
    let constituents: [String]
}

// For LookupSymbols
struct SymbolsLookup: Codable {
    let result: [StockSymbol]
}

struct StockSymbol: Codable {
    let symbol: String
}
