import UIKit

final class BasicFinancialsViewController: UIViewController {
    // MARK: - Properties
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var tenDayAverageTradingVolumeLabel = makeStaticInformationLabel(with: "Average Trading Volume")
    private lazy var tenDayAverageTradingVolume = makeDynamicInformationLabel()
    
    private lazy var weekHighLabel = makeStaticInformationLabel(with: "52 Week High")
    private lazy var weekHigh = makeDynamicInformationLabel()
    
    private lazy var weekLowLabel = makeStaticInformationLabel(with: "52 Week Low")
    private lazy var weekLow = makeDynamicInformationLabel()
    
    private lazy var weekPriceReturnDailyLabel = makeStaticInformationLabel(with: "Week Price Return Daily")
    private lazy var weekPriceReturnDaily = makeDynamicInformationLabel()
    
    private lazy var marketCapitalizationLabel = makeStaticInformationLabel(with: "Market Capitalization")
    private lazy var marketCapitalization = makeDynamicInformationLabel()
    
    private lazy var betaLabel = makeStaticInformationLabel(with: "Beta")
    private lazy var beta = makeDynamicInformationLabel()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
    }
    
    // MARK: - Public
    
    func update(with viewModel: BasicFinancialsViewModel) {
        tenDayAverageTradingVolume.text = viewModel.tenDayAverageTradingVolume
        weekHigh.text = viewModel.weekHigh52
        weekLow.text = viewModel.weekLow52
        weekPriceReturnDaily.text = viewModel.weekPriceReturnDaily52
        marketCapitalization.text = viewModel.marketCapitalization
        beta.text = viewModel.beta
    }
    
    // MARK: - Private
    
    private func setup() {
        view.addSubview(stackView)
        
        let tenDayAverageVolumeStack = UIStackView()
        let weekHighStack = UIStackView()
        let weekLowStack = UIStackView()
        let weekPriceReturnDailyStack = UIStackView()
        let marketCapitalizationStack = UIStackView()
        let betaStack = UIStackView()
        
        stackView.addArrangedSubview(tenDayAverageVolumeStack)
        stackView.addArrangedSubview(weekHighStack)
        stackView.addArrangedSubview(weekLowStack)
        stackView.addArrangedSubview(weekPriceReturnDailyStack)
        stackView.addArrangedSubview(marketCapitalizationStack)
        stackView.addArrangedSubview(betaStack)
        
        tenDayAverageVolumeStack.axis = .horizontal
        tenDayAverageVolumeStack.addArrangedSubview(tenDayAverageTradingVolumeLabel)
        tenDayAverageVolumeStack.addArrangedSubview(tenDayAverageTradingVolume)
        
        weekHighStack.axis = .horizontal
        weekHighStack.addArrangedSubview(weekHighLabel)
        weekHighStack.addArrangedSubview(weekHigh)
        
        weekLowStack.axis = .horizontal
        weekLowStack.addArrangedSubview(weekLowLabel)
        weekLowStack.addArrangedSubview(weekLow)
        
        weekPriceReturnDailyStack.axis = .horizontal
        weekPriceReturnDailyStack.addArrangedSubview(weekPriceReturnDailyLabel)
        weekPriceReturnDailyStack.addArrangedSubview(weekPriceReturnDaily)
        
        marketCapitalizationStack.axis = .horizontal
        marketCapitalizationStack.addArrangedSubview(marketCapitalizationLabel)
        marketCapitalizationStack.addArrangedSubview(marketCapitalization)
        
        betaStack.axis = .horizontal
        betaStack.addArrangedSubview(betaLabel)
        betaStack.addArrangedSubview(beta)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: beta.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func makeStaticInformationLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.gray
        label.font = UIFont(name: "Apple SD Gothic Neo Regular", size: 18)
        return label
    }
    
    private func makeDynamicInformationLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo Bold", size: 20)
        label.textAlignment = .right
        return label
    }
    
}
