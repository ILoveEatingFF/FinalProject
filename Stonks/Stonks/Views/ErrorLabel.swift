import UIKit

class ErrorLabel: UILabel {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.textColor = .red
        self.isHidden = true
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder init not implemented")
    }
}
