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
    private var searchViewModels: [StockCardViewModel] = []
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
      }
    
    var isSearched: Bool {
        !isSearchBarEmpty && searchController.isActive
    }

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
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
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
    func updateSearch(with viewModels: [StockCardViewModel]) {
        searchViewModels = viewModels
        collectionView.reloadData()
    }
    
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
        isSearched ? searchViewModels.count : viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockCardCell.identifier, for: indexPath) as? StockCardCell else {
            return UICollectionViewCell()
        }
        let viewModel: StockCardViewModel
        if isSearched {
            viewModel = searchViewModels[indexPath.item]
        } else {
            viewModel = viewModels[indexPath.item]
        }
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
            if !isSearched && output.hasNextPage {
                footer.startLoading()
            } else {
                footer.endLoading()
            }
            return footer
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel: StockCardViewModel
        if isSearched {
            viewModel = searchViewModels[indexPath.item]
        } else {
            viewModel = viewModels[indexPath.item]
        }
        output.didSelectStock(viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        output.willDisplay(at: indexPath.item, cellCount: viewModels.count, isSearched: isSearched)
    }
}

// MARK: - StockCardDelegate

extension FeedViewController: StockCardDelegate {
    func onTapFavorite(_ cell: StockCardCell, isFavorite: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let symbolToFavorite: String
        if isSearched {
            symbolToFavorite = searchViewModels[indexPath.item].symbol
            searchViewModels[indexPath.item].isFavorite = isFavorite
            if let index = findViewModelIndex(viewModels, with: symbolToFavorite) {
                viewModels[index].isFavorite = isFavorite
            }
        } else {
            symbolToFavorite = viewModels[indexPath.item].symbol
            viewModels[indexPath.item].isFavorite = isFavorite
        }
        output.didTapOnFavorite(symbol: symbolToFavorite, isFavorite: isFavorite)
        
        NotificationCenter.default.post(
            name: .didChangeFavorite,
            object: self,
            userInfo: ["symbol": viewModels[indexPath.item].symbol]
        )
    }
    
    private func findViewModelIndex(_ viewModels: [StockCardViewModel], with symbol: String) -> Int? {
        var index: Int? = nil
        for (i, viewModel) in viewModels.enumerated() {
            if viewModel.symbol == symbol {
                index = i
                break
            }
        }
        return index
    }
}

// MARK: - UISearchResultsUpdating

extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchSymbols), object: nil)
        self.perform(#selector(searchSymbols), with: nil, afterDelay: 0.5)
        searchSymbols(searchController.searchBar.text!)
    }
    
    @objc
    private func searchSymbols(_ searchText: String) {
        output.searchSymbols(searchText)
    }
}

// MARK: - UISearchBarDelegate

extension FeedViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        searchSymbols(searchText)
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
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

