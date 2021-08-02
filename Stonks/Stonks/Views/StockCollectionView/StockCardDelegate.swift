import Foundation

protocol StockCardDelegate: AnyObject {
    func onTapFavorite(_ cell: StockCardCell, isFavorite: Bool)
}
