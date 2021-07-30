import XCTest

protocol PageObject {
    var app: XCUIApplication { get }
}

class LoginPage: PageObject {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    @discardableResult
    func typeUsername(text: String) -> LoginPage {
        let loginTF = loginTextField
        loginTF.tap()
        loginTF.typeText(text)
        return self
    }
    
    @discardableResult
    func typePassword(text: String) -> LoginPage {
        let passwordTF = passwordTextField
        passwordTF.tap()
        passwordTF.typeText(text)
        return self
    }
    
    @discardableResult
    func tapSignInButton() -> LoginPage {
        signInButton.tap()
        return self
    }
    
    var passwordTextField: XCUIElement {
        app.secureTextFields["Пароль"]
    }
    
    var loginTextField: XCUIElement {
        app.textFields["Логин"]
    }
    
    var signInButton: XCUIElement {
        return app.buttons["Войти"]
    }
}
