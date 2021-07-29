import UIKit

final class SegmentCollectionViewController: UICollectionViewController {
    var viewModels: [SegmentViewModel] = []
    
    var selectedViewModel: SegmentViewModel? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
            return nil
        }
        return viewModels[indexPath.item]
    }
    
    init(viewModels: [SegmentViewModel]) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = CGSize(width: 1, height: 69)
        collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        self.viewModels = viewModels
        super.init(collectionViewLayout: collectionViewLayout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        collectionView.backgroundColor = .white
        collectionView.register(SegmentCardCell.self, forCellWithReuseIdentifier: SegmentCardCell.identifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SegmentCardCell.identifier,
                for: indexPath
        ) as? SegmentCardCell else {
            fatalError("Unexpected cell in SegmentCollectionView")}
        let model = viewModels[indexPath.item]
        cell.update(with: model)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard
            let selectedIndex = collectionView.indexPathsForSelectedItems?.first,
            selectedIndex != indexPath
        else {
            return false
        }
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModels[indexPath.item].onTapSegment?()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
