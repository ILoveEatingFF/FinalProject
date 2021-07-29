import UIKit

final class NewsCollectionViewController: UICollectionViewController {
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
        
        self.layout.estimatedItemSize = CGSize(width: self.collectionView.frame.width, height: 1.0)
        self.layout.itemSize = CGSize(width: self.collectionView.frame.width, height: UICollectionViewFlowLayout.automaticSize.height)
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
        
        cell.update(with: viewModels[indexPath.item])
//        imageLoader.load(url: URL(string: viewModel.image)) { [weak cell, viewModel] image in
//            guard let cell = cell else { return }
//            if cell.currentImageURL == viewModel.image {
//                cell.updateImage(with: image)
//            }
//        }
        
        return cell
    }
}

//extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let part: CGFloat = 0.5
//        let width = collectionView.frame.width
//        let height = width * part
//        return CGSize(width: width, height: height)
//    }
//}

private extension NewsCollectionViewController {
    enum Constants {
        static let backgroundColor = UIColor.white
        static let sectionsNumber = 1
    }
}
