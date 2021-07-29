import Foundation

enum Currency: String {
    case usd = "USD"
    case rub = "RUB"
    case eur = "EUR"
    case yuan = "CNY"
}

var currencyDictionary: [String : String] = [
    "USD": "$",
    "RUB": "₽",
    "EUR": "€",
    "CNY": "¥"
]
