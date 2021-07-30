import XCTest
@testable import Stonks

class CoreDataTests: XCTestCase {
    //add
    var coreDataStack: CoreDataStack!
    var databaseService: DatabaseServiceProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        coreDataStack = MockCoreDataStack()
        databaseService = DatabaseService(coreDataStack: coreDataStack)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        coreDataStack = nil
        databaseService = nil
    }
    
    func testThatStonksAreSaved() {
        //act
        let stonks: [StonkDTO] = [
            StonkDTO(symbol: "S", quote: Quote(symbol: "S", companyName: "s", latestPrice: 2, change: 3, currency: "USD"), logo: Logo(url: ""), isFavorite: nil)
        ]
        
        updateStonksAndWait(stonks: stonks, wait: 2.0)
        
        let extractedStonks = databaseService.getStonks(with: ["S"])
        
        //assert
        XCTAssertEqual(stonks, extractedStonks)
    }
    
    func testThatStonksAreRemoved() {
        let stonks: [StonkDTO] = [
            StonkDTO(symbol: "S", quote: Quote(symbol: "S", companyName: "s", latestPrice: 2, change: 3, currency: "USD"), logo: Logo(url: ""), isFavorite: nil),
            StonkDTO(symbol: "Y", quote: Quote(symbol: "Y", companyName: "s", latestPrice: 2, change: 3, currency: "USD"), logo: Logo(url: ""), isFavorite: nil)
        ]
        
        updateStonksAndWait(stonks: stonks, wait: 2.0)
        
        expectation(
          forNotification: .NSManagedObjectContextDidSave,
          object: coreDataStack.backgroundContext) {
            notification in
            return true
        }
        databaseService.delete(stonks: stonks)
        waitForExpectations(timeout: 2.0) { error in
          XCTAssertNil(error, "Save did not occur")
        }
        
        let extractedStonks = databaseService.getStonks(with: ["S", "Y"])
        XCTAssertEqual(extractedStonks, [])
    }
    
    func testThatStonksAreUpdated() {
        let stonks: [StonkDTO] = [
            StonkDTO(symbol: "S", quote: Quote(symbol: "S", companyName: "s", latestPrice: 2, change: 3, currency: "USD"), logo: Logo(url: ""), isFavorite: nil)
        ]
        updateStonksAndWait(stonks: stonks, wait: 2.0)
        
        let updatedStonks: [StonkDTO] = [
            StonkDTO(symbol: "S", quote: Quote(symbol: "S", companyName: "somali", latestPrice: 1000, change: 2010, currency: "USD"), logo: Logo(url: "someLogo"), isFavorite: nil)
        ]
        updateStonksAndWait(stonks: updatedStonks, wait: 2.0)
        
        let extractedStonks = databaseService.getStonks(with: ["S"])
        
        XCTAssertEqual(extractedStonks, updatedStonks)
    }
    
    func testThatFavoritesAreSaved() {
        //act
        let username = "testUser"
        databaseService.saveUser(username: username)
        
        let stonks: [StonkDTO] = [
            StonkDTO(symbol: "S", quote: Quote(symbol: "S", companyName: "s", latestPrice: 2, change: 3, currency: "USD"), logo: Logo(url: ""), isFavorite: nil)
        ]
        updateStonksAndWait(stonks: stonks, wait: 2.0)
        
        databaseService.saveUserFavorite(username: username, symbol: "S", isFavorite: true)
        
        let extractedStonks = databaseService.getFavorites(username: username)
        
        let answerStonks = [
            StonkDTO(symbol: "S", quote: Quote(symbol: "S", companyName: "s", latestPrice: 2, change: 3, currency: "USD"), logo: Logo(url: ""), isFavorite: true)
        ]
        
        XCTAssertEqual(extractedStonks, answerStonks)
    }
    
    func testThatFavoritesAreDeleted() {
        //act
        let username = "testUser"
        databaseService.saveUser(username: username)
        
        let stonks: [StonkDTO] = [
            StonkDTO(symbol: "S", quote: Quote(symbol: "S", companyName: "s", latestPrice: 2, change: 3, currency: "USD"), logo: Logo(url: ""), isFavorite: nil)
        ]
        updateStonksAndWait(stonks: stonks, wait: 2.0)
        
        // Save
        databaseService.saveUserFavorite(username: username, symbol: "S", isFavorite: true)
        
        // Delete
        databaseService.saveUserFavorite(username: username, symbol: "S", isFavorite: false)
        let extractedStonks = databaseService.getFavorites(username: username)
        
        XCTAssertEqual(extractedStonks, [])
    }
    
    func testThatIndexSymbolsAreSaved() {
        let index: MarketIndex = .sp500
        let symbols = ["AAPL", "GOOG", "MSFT"]
        
        updateMarketIndexAndWait(index: index, symbols: symbols, wait: 2.0)
        
        let extractedSymbols = databaseService.getIndexSymbols(index: index)
        
        XCTAssertEqual(symbols, extractedSymbols)
    }
    
    func testThatIndexSymbolsAreUpdated() {
        let index: MarketIndex = .sp500
        let symbols = ["AAPL", "GOOG", "MSFT"]
        
        updateMarketIndexAndWait(index: index, symbols: symbols, wait: 2.0)
        let newSymbols = ["AAPL", "AMZN", "MSFT"]
        updateMarketIndexAndWait(index: index, symbols: newSymbols, wait: 2.0)
        let extractedSymbols = databaseService.getIndexSymbols(index: index)
        
        XCTAssertEqual(newSymbols, extractedSymbols)
    }
    
    private func updateStonksAndWait(stonks: [StonkDTO], wait: TimeInterval) {
        expectation(
          forNotification: .NSManagedObjectContextDidSave,
          object: coreDataStack.backgroundContext) {
            notification in
            return true
        }
        databaseService.update(stonks: stonks, marketIndex: nil)
        waitForExpectations(timeout: wait) { error in
          XCTAssertNil(error, "Save did not occur")
        }
    }
    
    private func updateMarketIndexAndWait(index: MarketIndex, symbols: [String], wait: TimeInterval) {
        expectation(
          forNotification: .NSManagedObjectContextDidSave,
          object: coreDataStack.backgroundContext) {
            notification in
            return true
        }
        databaseService.updateIndexSymbols(index: index, symbols: symbols)
        waitForExpectations(timeout: wait) { error in
          XCTAssertNil(error, "Save did not occur")
        }
    }
    
}

