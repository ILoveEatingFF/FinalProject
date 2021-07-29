import Foundation

protocol StockCardDelegate: class {
    func onTapFavorite(_ cell: StockCardCell, isFavorite: Bool)
}
