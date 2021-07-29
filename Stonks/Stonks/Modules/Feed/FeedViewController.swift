//
//  FeedViewController.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import UIKit

final class FeedViewController: UIViewController {
    // MARK: - Properties
    
	private let output: FeedViewOutput
    private let imageLoader: ImageLoaderProtocol
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    private let searchController = UISearchController()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var viewModels: [StockCardViewModel] = []

    // MARK: - Lifecycle
    
    init(output: FeedViewOutput, imageLoader: ImageLoaderProtocol) {
        self.output = output
        self.imageLoader = imageLoader
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = Constants.backgroundColor
        setup()
        setupConstraints()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        output.didLoadView()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.willViewAppear()
    }
    
    // MARK: - Private
    
    private func setup() {
        setupCollectionView()
        setupSearch()
        setupActivityIndicators()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = Constants.backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StockCardCell.self, forCellWithReuseIdentifier: StockCardCell.identifier)
        collectionView.register(FooterLoaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoaderView.identifier)
    }
    
    private func setupSearch() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.placeholder = "Поиск"
//        searchController.searchResultsUpdater = self
//        searchController.delegate = self
    }
    
    private func setupActivityIndicators() {
        view.addSubview(activityIndicator)
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }
    
    private func setupConstraints() {
        [collectionView,
         activityIndicator].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
}

// MARK: - FeedViewInput

extension FeedViewController: FeedViewInput {
    func update(with viewModels: [StockCardViewModel]) {
        self.viewModels = viewModels
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - Constants.cellPadding
        let height: CGFloat = 70.0
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Constants.segmentHeight, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width - Constants.cellPadding
        let height: CGFloat = output.hasNextPage ? Constants.shownFooterHeight : Constants.hiddenFooterHeight
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockCardCell.identifier, for: indexPath) as? StockCardCell else {
            return UICollectionViewCell()
        }
        let viewModel = viewModels[indexPath.item]
        cell.update(with: viewModel)
        imageLoader.load(url: URL(string: viewModel.logo)) { [weak cell, viewModel] image in
            guard let cell = cell else { return }
            if cell.currentImageURL == viewModel.logo {
                cell.setLogo(image)
            }
        }
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter,
           let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLoaderView.identifier, for: indexPath) as? FooterLoaderView {
            output.hasNextPage ? footer.startLoading() : footer.endLoading()
            return footer
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.didSelectStock(viewModels[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        output.willDisplay(at: indexPath.item, cellCount: viewModels.count)
    }
}

// MARK: - StockCardDelegate

extension FeedViewController: StockCardDelegate {
    func onTapFavorite(_ cell: StockCardCell, isFavorite: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        viewModels[indexPath.item].isFavorite = isFavorite
        output.didTapOnFavorite(symbol: viewModels[indexPath.item].symbol, isFavorite: isFavorite)
        
        NotificationCenter.default.post(
            name: .didChangeFavorite,
            object: self,
            userInfo: ["symbol": viewModels[indexPath.item].symbol]
        )
    }
}

// MARK: - Nested Types

private extension FeedViewController {
    enum Constants {
        static let backgroundColor: UIColor = .white
        static let cellPadding: CGFloat = 32.0
        static let interItemSpacing: CGFloat = 8.0
        static let segmentHeight: CGFloat = 20.0
        static let shownFooterHeight: CGFloat = 50
        static let hiddenFooterHeight: CGFloat = 0
    }
}

