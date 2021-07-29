import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Light", size: 12)
        return label
    }()
    
    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Bold", size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2021-20-22"
        label.font = UIFont(name: "Helvetica Light", size: 12)
        return label
    }()
    
    private let imageView = UIImageView()
    
    var currentImageURL: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(
            _ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(layoutAttributes.size,
                withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    private func setup() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(sourceLabel)
        stackView.addArrangedSubview(headlineLabel)
        stackView.addArrangedSubview(summaryLabel)
        stackView.addArrangedSubview(dateLabel)
        
        summaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        summaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
//        backgroundColor = .lightGray
//        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    private func setupConstraints() {
        [stackView,
         summaryLabel,
         headlineLabel].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            summaryLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            headlineLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 45)
        ])
    }
    
    
    func update(with viewModel: NewsViewModel) {
        sourceLabel.text = viewModel.source
        headlineLabel.text = viewModel.headline
        summaryLabel.text = viewModel.summary
        currentImageURL = viewModel.image
    }
    
    func updateImage(with image: UIImage?) {
        imageView.image = image
    }
}
