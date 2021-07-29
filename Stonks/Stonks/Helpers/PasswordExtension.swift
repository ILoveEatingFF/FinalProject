import Foundation

let passwordRegex = "^(.{0,6}|[^0-9]*|[^A-Z]*|[^a-z]*)$"
let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

extension String {
    func isPassword() -> Bool {
        !passwordPredicate.evaluate(with: self)
    }
}
