import UIKit

protocol LoginModuleInput: class {
	var moduleOutput: LoginModuleOutput? { get }
    func didSignUp(username: String, password: String)
}

protocol LoginModuleOutput: class {
    func startApp()
    func showSignUp()
}

protocol LoginViewInput: class {
    func showSignInError()
    func setUsernameAndPassword(username: String, password: String)
}

protocol LoginViewOutput: class {
    func login(username: String, password: String)
    func signUp()
}

protocol LoginInteractorInput: class {
    func signIn(username: String, password: String)
}

protocol LoginInteractorOutput: class {
    func didSignIn()
    func didNotSignIn()
}

protocol LoginRouterInput: class {
    func push(_ vc: UIViewController, animated: Bool)
    func popToRootVC(animated: Bool )
}
