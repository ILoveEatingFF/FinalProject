import UIKit

protocol NewsDelegate: AnyObject {
    func didTapOnNews(_ newsUrl: String)
}

final class NewsCollectionViewController: UICollectionViewController {
    weak var delegate: NewsDelegate?
    
    private var viewModels: [NewsViewModel] = []
    private let imageLoader: ImageLoaderProtocol
    private let layout: UICollectionViewFlowLayout
    
    init(
        viewModels: [NewsViewModel],
        imageLoader: ImageLoaderProtocol,
        collectionViewLayout: UICollectionViewFlowLayout
    ) {
        self.viewModels = viewModels
        self.imageLoader = imageLoader
        self.layout = collectionViewLayout
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.layout.estimatedItemSize = CGSize(width: self.collectionView.frame.width, height: 50)
        self.layout.itemSize = CGSize(width: self.collectionView.frame.width, height: UICollectionViewFlowLayout.automaticSize.height)
    }
    
    func update(with viewModels: [NewsViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }
    
    private func setup() {
        collectionView.backgroundColor = Constants.backgroundColor
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        Constants.sectionsNumber
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else {
            assertionFailure("NewsCollectionViewCell not found")
            return UICollectionViewCell()
        }
        let viewModel = viewModels[indexPath.item]
        
        cell.update(with: viewModel)
//        imageLoader.load(url: URL(string: viewModel.image)) { [weak cell, viewModel] image in
//            guard let cell = cell else { return }
//            if cell.currentImageURL == viewModel.image {
//                cell.updateImage(with: image)
//            }
//        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapOnNews(viewModels[indexPath.item].url)
    }
}

private extension NewsCollectionViewController {
    enum Constants {
        static let backgroundColor = UIColor.white
        static let sectionsNumber = 1
    }
}
