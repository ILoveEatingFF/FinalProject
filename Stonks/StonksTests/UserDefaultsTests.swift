import XCTest
@testable import Stonks

class UserDefaultsTets: XCTestCase {
    // add
    var defaultsService: StorageServiceProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        defaultsService = DefaultStorageService()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        defaultsService.remove(for: "testUser")
        defaultsService = nil
    }
    
    func testThatObjectSaved() {
        // act
        let username = "testUser1"
        defaultsService.save(object: username, for: "testUser")
        let extractedUser: String? = defaultsService.get(for: "testUser")
        
        // assert
        XCTAssertEqual(username, extractedUser)
    }
    
    func testThatObjectIsDeleted() {
        // act
        let username = "testUser1"
        defaultsService.save(object: username, for: "testUser")
        defaultsService.remove(for: "testUser")
        
        let extractedUser: String? = defaultsService.get(for: "testUser")
        
        // assert
        XCTAssertNil(extractedUser)
    }
    
    func testThatObjectIsUpdated() {
        // act
        let firstUsername = "testFirstUsername"
        let secondUsername = "testSecondUsername"
        defaultsService.save(object: firstUsername, for: "testUser")
        defaultsService.save(object: secondUsername, for: "testUser")
        
        let extractedUser: String? = defaultsService.get(for: "testUser")
        
        // assert
        XCTAssertEqual(secondUsername, extractedUser)
    }
}
