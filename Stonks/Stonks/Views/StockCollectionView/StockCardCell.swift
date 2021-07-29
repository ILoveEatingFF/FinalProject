import UIKit

final class StockCardCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private var isFavorite: Bool = false {
        didSet {
            let color = isFavorite ? Color.starYellow : Color.starGray
            favoriteImageView.image = UIImage(named: "Star.fill")?.withTintColor(color)
        }
    }

    weak var delegate: StockCardDelegate?
    
    var currentImageURL: String = ""

    //MARK: - Views
    
    private let containerView = UIView()

    private let logo = UIImageView(image: UIImage(named: "companyPlaceholder"))

    private let nameFavStack = UIStackView()
    private let middleStack = UIStackView()
    private let favoriteImageView = UIImageView(image: UIImage(named: "Star.fill"))
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo Bold", size: 18.0)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 12)
        return label
    }()

    private let rightStack = UIStackView()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo Bold", size: 18.0)
        label.textAlignment = .right
        return label
    }()
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 13)
        label.textAlignment = .right
        return label
    }()

    private let tapGesture = UITapGestureRecognizer()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
        favoriteImageView.isUserInteractionEnabled = true
    }

    required init(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private
    
    private func setup() {

        containerView.layer.cornerRadius = 16.0
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white

        contentView.addSubview(containerView)
        containerView.addSubview(logo)
        containerView.addSubview(middleStack)
        containerView.addSubview(rightStack)

        nameFavStack.axis = .horizontal
        nameFavStack.spacing = 6.0
        nameFavStack.distribution = .fill
        nameFavStack.addArrangedSubview(nameLabel)
        nameFavStack.addArrangedSubview(favoriteImageView)

        middleStack.axis = .vertical
        middleStack.alignment = .leading
        middleStack.spacing = 2.0
        middleStack.addArrangedSubview(nameFavStack)
        middleStack.addArrangedSubview(descriptionLabel)

        rightStack.axis = .vertical
        rightStack.alignment = .center
        rightStack.addArrangedSubview(priceLabel)
        rightStack.addArrangedSubview(changeLabel)

        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(handleTapGesture(_:)))
        favoriteImageView.addGestureRecognizer(tapGesture)
    }

    private func setupConstraints() {
        [containerView,
         logo,
         favoriteImageView,
         middleStack,
         rightStack].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}

        let heightLogoConstraint = logo.heightAnchor.constraint(equalToConstant: 52)
        heightLogoConstraint.priority = UILayoutPriority(rawValue: 999)
        heightLogoConstraint.isActive = true

        let favHeightConstraint = favoriteImageView.heightAnchor.constraint(equalToConstant: 20)
        let favWidthConstraint = favoriteImageView.widthAnchor.constraint(equalToConstant: 20)
        favHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        favWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        [favWidthConstraint, favHeightConstraint].forEach {$0.isActive = true}

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            logo.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0),
            logo.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 8.0),
            logo.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
            logo.widthAnchor.constraint(equalToConstant: 52.0),

            middleStack.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 10.0),
            middleStack.trailingAnchor.constraint(lessThanOrEqualTo: rightStack.leadingAnchor, constant: -10.0),
            middleStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14.0),
            middleStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14.0),


            rightStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0),
            rightStack.topAnchor.constraint(equalTo: middleStack.topAnchor),
            rightStack.bottomAnchor.constraint(equalTo: middleStack.bottomAnchor),

        ])
    }

    func update(with viewModel: StockCardViewModel) {
        self.isFavorite = viewModel.isFavorite
        nameLabel.text = viewModel.symbol
        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.change
        logo.image = UIImage(named: "companyPlaceholder")
        switch viewModel.changeColor {
        case .red:
            changeLabel.textColor = .systemRed
        case .green:
            changeLabel.textColor = .systemGreen
        }
        switch viewModel.backgroundColor {
        case .lightBlue:
            containerView.backgroundColor = Color.lightBlue
        case .lightGray:
            containerView.backgroundColor = Color.lightGray2
        }
        
        currentImageURL = viewModel.logo
    }
    
    func setLogo(_ image: UIImage?) {
        logo.image = image
    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        isFavorite = !isFavorite
        delegate?.onTapFavorite(self, isFavorite: isFavorite)
    }
}
