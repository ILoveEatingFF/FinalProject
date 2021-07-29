import UIKit

enum Color {
    static let lightGray = UIColor.rgba(232, 232, 232)
    static let lightGray2 = UIColor.rgba(236, 238, 242)
    static let lightBlack = UIColor.rgba(46, 49, 49)
    static let starYellow = UIColor.rgba(255, 202, 28)
    static let starGray = UIColor.rgba(186, 186, 186)
    static let lightBlue = UIColor.rgba(210, 236, 250)
}

extension UIColor {
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
