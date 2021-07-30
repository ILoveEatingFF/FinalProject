//
//  StonksUITests.swift
//  StonksUITests
//
//  Created by Иван Лизогуб on 15.07.2021.
//

import XCTest

class LoginTests: XCTestCase {
    
    var app: XCUIApplication!
    var loginPage: LoginPage!

    override func setUpWithError() throws {
        app = XCUIApplication()
        loginPage = LoginPage(app: app)
        app.launchArguments.append(LaunchArgumentsConstants.isUITesting)
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
        loginPage = nil
    }

    func testThatLoginButtonIsDisabledWithEmptyUsernameAndPassword() throws {
        XCTAssertFalse(loginPage.signInButton.isEnabled)
    }
    
    func testThatLoginButtonIsDisabledWithEmptyUsernameAndFilledPassword() throws {
        loginPage.typePassword(text: "P@ssw0rd")
        XCTAssertFalse(loginPage.signInButton.isEnabled)
    }
    
    func testThatLoginButtonIsDisabledWithFilledUsernameAndEmptyPassword() throws {
        loginPage.typeUsername(text: "User")
        XCTAssertFalse(loginPage.signInButton.isEnabled)
    }

    func testThatLoginButtonIsClickableWithFilledUsernameAndFilledPassword() throws {
        loginPage.typeUsername(text: "User")
        loginPage.typePassword(text: "P@ssw0rd")
        XCTAssertTrue(loginPage.signInButton.isEnabled)
    }
}
