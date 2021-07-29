import Foundation

struct StonkResponse: Codable {
    
    var stonks: [StonkDTO]
    
    init(stonks: [StonkDTO]) {
        self.stonks = stonks
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
    }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
            
            var stonks: [StonkDTO] = []
            
            for key in container.allKeys {
                
                var decodedObject = try container.decode(StonkDTO.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                decodedObject.symbol = key.stringValue
                stonks.append(decodedObject)
            }
            
            self.stonks = stonks
//            print(stonks)
        }
}

struct StonkDTO: Codable, Hashable {
    var symbol: String?
    let quote: Quote
    let logo: Logo
    let isFavorite: Bool?
}

struct Logo: Codable, Hashable {
    let url: String?
}

struct Quote: Codable, Hashable {
    let symbol: String
    let companyName: String
    let latestPrice: Double?
    let change: Double?
}
