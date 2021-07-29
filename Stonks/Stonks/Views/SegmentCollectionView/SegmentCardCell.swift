import UIKit

final class SegmentCardCell: UICollectionViewCell {
    var name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 20.0)
        label.textColor = .lightGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("StoryBoard init not implemented in SegmentCardCell")
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                name.font = UIFont(name: "Montserrat-Bold", size: 26)
                name.textColor = .black
            } else {
                name.font = UIFont(name: "Montserrat-Regular", size: 20)
                name.textColor = .lightGray
            }
        }
    }

    override func preferredLayoutAttributesFitting(
            _ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(contentView.frame.size,
                withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
        return layoutAttributes
    }

    private func setup() {
        contentView.addSubview(name)
    }

    private func setupConstraints() {
        [name].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}

        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            name.topAnchor.constraint(equalTo: contentView.topAnchor),
            name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func update(with viewModel: SegmentViewModel) {
        name.text = viewModel.name
    }
}

