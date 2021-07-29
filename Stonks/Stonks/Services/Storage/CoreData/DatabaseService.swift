import Foundation
import CoreData

final class DatabaseService {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}

extension DatabaseService: DatabaseServiceProtocol {
    
    func update(stonks: [StonkDTO], marketIndex: MarketIndex? = nil) {
        let backgroundContext = coreDataStack.backgroundContext
        backgroundContext.perform {
            let fetchStonksRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
            let symbols = stonks.compactMap( { $0.symbol } )
            fetchStonksRequest.predicate = NSPredicate(format: "symbol in %@", argumentArray: [symbols])
            
            var fundIndex: FundIndex?
            if let marketIndex = marketIndex {
                let fetchFundIndexRequest: NSFetchRequest<FundIndex> = FundIndex.fetchRequest()
                fetchFundIndexRequest.predicate = NSPredicate(format: "symbol == %@", marketIndex.rawValue)
                fundIndex = try? backgroundContext.fetch(fetchFundIndexRequest).first
            }
            
            if let intersectedStocks = try? backgroundContext.fetch(fetchStonksRequest) {
                let intersectedStocksDict: [String: Stock] =
                    intersectedStocks.reduce(into: [String: Stock]()) { $0[$1.symbol ?? ""] = $1 }
                stonks.forEach {
                    if let stock = intersectedStocksDict[$0.symbol ?? ""] {
                        stock.update(with: $0)
                    } else {
                        let stock = Stock(context: backgroundContext)
                        stock.update(with: $0)
                        if let fundIndex = fundIndex {
                            stock.addToFundIndex(fundIndex)
                        }
                    }
                }
            } else {
                stonks.forEach {
                    let stock = Stock(context: backgroundContext)
                    stock.update(with: $0)
                    if let fundIndex = fundIndex {
                        stock.addToFundIndex(fundIndex)
                    }
                }
            }
            
            
            if backgroundContext.hasChanges {
                do {
                    try backgroundContext.save()
                } catch {
                    print("Error saving while updating objects \(error.localizedDescription)")
                }
            }
        }
    }
    
    func delete(stonks: [StonkDTO]) {
//        Удаляем объекты через контекст, а не используем NSBatchDeleteRequest, так как он удаляет объекты
//        из NSPersistentStore, и не производит валидацию модели и отношений между сущностями пруфы:
//        https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
        
        let backgroundContext = coreDataStack.backgroundContext
        backgroundContext.perform {
            stonks.forEach {
                let fetchRequest = self.fetchRequest(for: $0)
                if let stock = try? backgroundContext.fetch(fetchRequest).first {
                    backgroundContext.delete(stock)
                }
            }
            
            if backgroundContext.hasChanges {
                do {
                    try backgroundContext.save()
                } catch {
                    print("Error saving while deleting objects \(error.localizedDescription)")
                }
            }
        }
    }
    
    func stonks(with predicate: NSPredicate?) -> [StonkDTO] {
        var result = [StonkDTO]()
        let context = coreDataStack.viewContext
        
        let request: NSFetchRequest<Stock> = Stock.fetchRequest()
        request.predicate = predicate
        
        context.performAndWait {
            guard let response = try? context.fetch(request) else { return }
            result = response.map { StonkDTO(with: $0) }
        }
        
        return  result
    }
    
    func getStonks(with symbols: [String]) -> [StonkDTO] {
        let predicate = NSPredicate(format: "symbol in %@", symbols)
        return stonks(with: predicate)
    }
    
    func saveUser(username: String) {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let predicate = NSPredicate(format: "username == %@", username)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let context = coreDataStack.viewContext
        context.performAndWait {
            do {
                if try context.fetch(fetchRequest).first == nil {
                    let user = User(context: context)
                    user.username = username
                }
            } catch {
                print("Error while fetching user \(error.localizedDescription)")
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Error while saving user favorite \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveUserFavorite(username: String, symbol: String, isFavorite: Bool) {
        let fetchUserRequest = NSFetchRequest<User>(entityName: "User")
        let userPredicate = NSPredicate(format: "username == %@", username)
        fetchUserRequest.predicate = userPredicate
        fetchUserRequest.fetchLimit = 1
        
        let fetchStockRequest = NSFetchRequest<Stock>(entityName: "Stock")
        let stockPredicate = NSPredicate(format: "symbol == %@", symbol)
        fetchStockRequest.predicate = stockPredicate
        
        let context = coreDataStack.viewContext
        context.performAndWait {
            do {
                if let user = try context.fetch(fetchUserRequest).first,
                   let stock = try context.fetch(fetchStockRequest).first {
                    if isFavorite {
                        user.addToStocks(stock)
                    } else {
                        user.removeFromStocks(stock)
                    }
                }
            } catch {
                print("Error while fetching in saveUserFavorite \(error.localizedDescription)")
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Error while saving user favorite \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getFavorites(username: String) -> [StonkDTO] {
        var result: [StonkDTO] = []
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let predicate = NSPredicate(format: "username == %@", username)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let context = coreDataStack.viewContext
        context.performAndWait {
            do {
                if let user = try context.fetch(fetchRequest).first,
                   let stocks = user.stocks?.allObjects as? [Stock] {
                    stocks.forEach {
                        result.append(StonkDTO(with: $0, isFavorite: true))
                    }
                }
            } catch {
                print("Error while fetching user \(error.localizedDescription)")
            }
        }
        return result
    }
    
    func getFavoritesSymbols(username: String) -> [String] {
        var result: [String] = []
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let predicate = NSPredicate(format: "username == %@", username)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let context = coreDataStack.viewContext
        context.performAndWait {
            do {
                if let user = try context.fetch(fetchRequest).first,
                   let stocks = user.stocks?.allObjects as? [Stock] {
                    stocks.forEach {
                        result.append($0.symbol ?? "")
                    }
                }
            } catch {
                print("Error while fetching user \(error.localizedDescription)")
            }
        }
        return result
    }
    
    func updateIndexSymbols(index: MarketIndex, symbols: [String]) {
        let context = coreDataStack.backgroundContext
        context.perform {
            let fetchRequest = NSFetchRequest<FundIndex>(entityName: "FundIndex")
            let predicate = NSPredicate(format: "symbol == %@", index.rawValue)
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1
            if let fundIndex = try? context.fetch(fetchRequest).first {
                let symbolsSet = Set<String>(symbols)
                let oldSymbols = self.getIndexSymbols(index: index)
                // Проходимся по предыдущим символам, если в новом наборе отсутствует элемент из предыдущего, то удаляем его из отношения
                oldSymbols.forEach {
                    if !symbolsSet.contains($0),
                       let stock = self.fetchStock(with: $0) {
                        fundIndex.removeFromCompanySymbols(stock)
                    }
                }
                
                fundIndex.allCompanySymbols = symbols.joined(separator: ",")
                fundIndex.symbol = index.rawValue
            } else {
                let fundIndex = FundIndex(context: context)
                fundIndex.allCompanySymbols = symbols.joined(separator: ",")
                fundIndex.symbol = index.rawValue
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Error while saving user favorite \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getIndexSymbols(index: MarketIndex) -> [String] {
        let context = coreDataStack.viewContext
        var result: [String] = []
        let fetchRequest = NSFetchRequest<FundIndex>(entityName: "FundIndex")
        let predicate = NSPredicate(format: "symbol == %@", index.rawValue)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        context.performAndWait {
            if let fundIndex = try? context.fetch(fetchRequest).first {
                guard let allCompanySymbols = fundIndex.allCompanySymbols else {
                    return
                }
                result = allCompanySymbols.components(separatedBy: CharacterSet(arrayLiteral: ","))
            }
        }
        
        return result
    }
    
    private func fetchStock(with symbol: String) -> Stock? {
        return fetchStock(predicate: NSPredicate(format: "symbol == %@", symbol)).first
    }
    
    private func fetchStock(predicate: NSPredicate?) -> [Stock] {
        var result: [Stock] = []
        let context = coreDataStack.backgroundContext
        let fetchRequest = NSFetchRequest<Stock>(entityName: "Stock")
        fetchRequest.predicate = predicate
        context.performAndWait {
            if let stocks = try? context.fetch(fetchRequest) {
                result = stocks
            }
        }
        return result
    }
}

private extension DatabaseService {
    func fetchRequest(for stonk: StonkDTO) -> NSFetchRequest<Stock> {
        let request: NSFetchRequest<Stock> = Stock.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", stonk.symbol ?? "")
        return request
    }
}

private extension Stock {
    func update(with stonk: StonkDTO) {
        self.symbol = stonk.symbol
        self.change = NSDecimalNumber(value: stonk.quote.change ?? 0)
        self.companyName = stonk.quote.companyName
        self.price = NSDecimalNumber(value: stonk.quote.latestPrice ?? 0)
        self.logoURL = stonk.logo.url
        self.currency = stonk.quote.currency
    }
}

private extension StonkDTO {
    init(with MO: Stock, isFavorite: Bool? = nil) {
        self.symbol = MO.symbol
        self.quote = Quote(with: MO)
        self.logo = Logo(with: MO)
        self.isFavorite = isFavorite
    }
}

private extension Quote {
    init(with MO: Stock) {
        self.symbol = MO.symbol ?? ""
        self.companyName = MO.companyName ?? ""
        self.latestPrice = MO.price?.doubleValue
        self.change = MO.change?.doubleValue
        self.currency = MO.currency
    }
}

private extension Logo {
    init(with MO: Stock) {
        self.url = MO.logoURL
    }
}
