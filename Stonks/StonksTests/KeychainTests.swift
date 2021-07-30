//
//  KeychainTests.swift
//  StonksTests
//
//  Created by Иван Лизогуб on 19.07.2021.
//

import XCTest
@testable import Stonks

class KeychainTests: XCTestCase {

    // add
    var keychainService: KeychainService!
    var genericPasswordQueryable: GenericPassword!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        keychainService = KeychainService()
        genericPasswordQueryable = GenericPassword(key: "genericPassword", username: "user")
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try? keychainService.removeAll(queryItem: genericPasswordQueryable)
        genericPasswordQueryable = nil
    }
    
    func testSaveGenericPassword() {
        // act
        do {
            try keychainService.setValue("pwd_123", queryItem: genericPasswordQueryable)
        // assert
        } catch {
            XCTFail("Failed to save generic password with error: \(error.localizedDescription)")
        }
    }
    
    func testThatGenericPasswordIsSaved() {
        do {
            try keychainService.setValue("pwd_123", queryItem: genericPasswordQueryable)
            let password: String? = try keychainService.getObject(queryItem: genericPasswordQueryable)
            
            XCTAssertEqual("pwd_123", password)
        } catch {
            XCTFail("Failed to read generic password with error: \(error.localizedDescription)")
        }
    }
    
    func testThatGenericPasswordIsUpdated() {
        do {
            try keychainService.setValue("pwd_123", queryItem: genericPasswordQueryable)
            try keychainService.setValue("pwd_124", queryItem: genericPasswordQueryable)
            let password: String? = try keychainService.getObject(queryItem: genericPasswordQueryable)
            
            XCTAssertEqual("pwd_124", password)
        } catch {
            XCTFail("Failed to update generic password with error: \(error.localizedDescription)")
        }
    }

    func testThatGenericPasswordIsRemoved() {
        do {
            try keychainService.setValue("pwd_123", queryItem: genericPasswordQueryable)
            try keychainService.removeObject(userName: genericPasswordQueryable.username, queryItem: genericPasswordQueryable)
            let password: String? = try keychainService.getObject(queryItem: genericPasswordQueryable)
            
            XCTAssertNil(password)
        } catch {
            XCTFail("Failed to remove generic password with error: \(error.localizedDescription)")
        }
    }
    
    func testThatGenericPasswordIsDeleted() {
        do {
            let genericPasswordQueryable1 = GenericPassword(key: "genericPassword", username: "user1")
            let genericPasswordQueryable2 = GenericPassword(key: "genericPassword", username: "user2")
            try keychainService.setValue("pwd_123", queryItem: genericPasswordQueryable1)
            try keychainService.setValue("pwd_125", queryItem: genericPasswordQueryable2)
            
            try keychainService.removeAll(queryItem: genericPasswordQueryable1)
            let firstPassword: String? = try keychainService.getObject(queryItem: genericPasswordQueryable1)
            let secondPassword: String? = try keychainService.getObject(queryItem: genericPasswordQueryable2)
            
            XCTAssertNil(firstPassword)
            XCTAssertNil(secondPassword)
        } catch {
            XCTFail("Failed to remove generic passwords with error: \(error.localizedDescription)")
        }
    }
}
