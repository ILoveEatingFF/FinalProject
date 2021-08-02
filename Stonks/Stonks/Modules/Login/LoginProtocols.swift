import UIKit

protocol LoginModuleInput: AnyObject {
	var moduleOutput: LoginModuleOutput? { get }
    func didSignUp(username: String, password: String)
}

protocol LoginModuleOutput: AnyObject {
    func startApp()
    func showSignUp()
}

protocol LoginViewInput: AnyObject {
    func showSignInError()
    func setUsernameAndPassword(username: String, password: String)
}

protocol LoginViewOutput: AnyObject {
    func login(username: String, password: String)
    func signUp()
}

protocol LoginInteractorInput: AnyObject {
    func signIn(username: String, password: String)
}

protocol LoginInteractorOutput: AnyObject {
    func didSignIn()
    func didNotSignIn()
}

protocol LoginRouterInput: AnyObject {
    func push(_ vc: UIViewController, animated: Bool)
    func popToRootVC(animated: Bool )
}
