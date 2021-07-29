import UIKit

final class DetailedStockViewController: UIViewController {
	private let output: DetailedStockViewOutput
    
    private lazy var segmentCollectionViewController = SegmentCollectionViewController(viewModels: setupSegmentViewModels())
    
    private var isFavorite: Bool = false {
        didSet {
            let color = isFavorite ? Color.starYellow : .white
            let image = isFavorite ? UIImage(named: "Star.fill")?.withTintColor(color) : UIImage(named: "Star")
            navigationItem.rightBarButtonItem?.image = image
        }
    }
    
    private let stock: StockCardViewModel
    
    private lazy var newsViewController: NewsCollectionViewController = {
        let imageLoader: ImageLoaderProtocol = ImageLoader()
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.minimumLineSpacing = 18
        let vc = NewsCollectionViewController(viewModels: [], imageLoader: imageLoader, collectionViewLayout: collectionViewLayout)
        return vc
    }()
    
    private lazy var childControllersForSegment: [UIViewController] = [newsViewController]

    init(output: DetailedStockViewOutput, stock: StockCardViewModel) {
        self.output = output
        self.stock = stock
        self.isFavorite = stock.isFavorite
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        setup()
        configureSegmentViewController()
        setupConstraints()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        segmentCollectionViewController.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
	}
    
    private func setup() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let image = isFavorite ? UIImage(named: "Star.fill")?.withTintColor(Color.starYellow) : UIImage(named: "Star")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(onTapFavorite))
        
        let title = makeAttributedNavigationTitle(symbol: stock.symbol, description: stock.description)
        let size = title.size()
        
        let width = size.width
        guard let height = navigationController?.navigationBar.frame.size.height else {return}
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
    }
    
    private func setupConstraints() {
        [segmentCollectionViewController.view].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentCollectionViewController.view.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentCollectionViewController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16.0),
            segmentCollectionViewController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            segmentCollectionViewController.view.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func configureSegmentViewController() {
        addChild(segmentCollectionViewController)
        view.addSubview(segmentCollectionViewController.view)
        segmentCollectionViewController.didMove(toParent: self)
    }
    
    private func setupSegmentViewModels() -> [SegmentViewModel] {
        var viewModels: [SegmentViewModel] = []
        let graphViewModel = SegmentViewModel(name: Segments.graph.rawValue) { [weak self] in
            guard let self = self else { return }
            self.childControllersForSegment.forEach {
                $0.remove()
            }
        }
        let newsViewModels = SegmentViewModel(name: Segments.news.rawValue) { [weak self] in
            guard let self = self else { return }
            self.childControllersForSegment.forEach {
                $0.remove()
            }
            self.onTapNews()
        }
        viewModels.append(graphViewModel)
        viewModels.append(newsViewModels)
        
        return viewModels
    }
    
    @objc
    private func onTapFavorite() {
        isFavorite = !isFavorite
        output.didTapOnFavorite(symbol: stock.symbol, isFavorite: isFavorite)
        
        NotificationCenter.default.post(
            name: .didChangeFavorite,
            object: self,
            userInfo: ["symbol": stock.symbol]
        )
    }
    
    private func onTapNews() {
        output.didTapNews(symbol: stock.symbol)
    }
    
    private func configureNewsViewController(viewModels: [NewsViewModel]) {
        newsViewController.update(with: viewModels)
        add(newsViewController)
        setupNewsConstraints(newsViewController.view)
    }
    
    private func setupNewsConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: segmentCollectionViewController.view.bottomAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension DetailedStockViewController: DetailedStockViewInput {
    func updateNews(with viewModels: [NewsViewModel]) {
        if let selectedModel = segmentCollectionViewController.selectedViewModel,
           selectedModel.name == Segments.news.rawValue {
            configureNewsViewController(viewModels: viewModels)
        }
    }
    
    func updateFavorite(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
}

// MARK: - Helpers

private extension DetailedStockViewController {
    func makeAttributedNavigationTitle(symbol: String, description: String) -> NSAttributedString {
        let titleParameters = [NSAttributedString.Key.font : UIFont(name: "Apple SD Gothic Neo Bold", size: 18.0)]
        let subtitleParameters = [NSAttributedString.Key.font : UIFont(name: "Apple SD Gothic Neo SemiBold", size: 12)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: symbol, attributes: titleParameters as [NSAttributedString.Key : Any])
        let subtitle:NSAttributedString = NSAttributedString(string: description, attributes: subtitleParameters as [NSAttributedString.Key : Any])
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)

        return title
    }
}

// MARK: - Nested Types

private extension DetailedStockViewController {
    enum Segments: String {
        case graph = "График"
        case news = "Новости"
        case forecats = "Прогнозы"
    }
}
