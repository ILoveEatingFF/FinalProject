import Foundation

protocol DatabaseServiceProtocol {
    func update(stonks: [StonkDTO], marketIndex: MarketIndex?)
    func delete(stonks: [StonkDTO])
    func stonks(with predicate: NSPredicate?) -> [StonkDTO]
    func getStonks(with symbols: [String]) -> [StonkDTO]
    
    func saveUserFavorite(username: String, symbol: String, isFavorite: Bool)
    func getFavorites(username: String) -> [StonkDTO]
    func getFavoritesSymbols(username: String) -> [String]
    
    func saveUser(username: String)
    
    func getIndexSymbols(index: MarketIndex) -> [String]
    func updateIndexSymbols(index: MarketIndex, symbols: [String])
}
