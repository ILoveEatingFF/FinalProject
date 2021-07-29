import Foundation

struct StockCardViewModel: Hashable {
    let symbol: String
    let description: String
    let price: String
    let change: String
    let logo: String
    let changeColor: ChangeColor
    let backgroundColor: BackgroundColor
    var isFavorite: Bool
    
    enum ChangeColor {
        case green, red
    }
    
    enum BackgroundColor {
        case lightBlue, lightGray
    }
}
