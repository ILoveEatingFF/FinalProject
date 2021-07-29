import UIKit

final class FooterLoaderView: UICollectionReusableView {
    private let activityIndicator = UIActivityIndicatorView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(activityIndicator)
        activityIndicator.style = .large
    }
    
    private func setupConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
//        self.isHidden = false
    }
    
    func endLoading() {
        activityIndicator.stopAnimating()
//        self.isHidden = true
    }
}
