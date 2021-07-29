import UIKit

class PaddingTextField: UITextField {
    
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    init(frame: CGRect = .zero, padding: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)) {
        self.padding = padding
        
        super.init(frame: frame)
        
        self.backgroundColor = Color.lightGray
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
}
