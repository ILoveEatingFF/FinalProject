//
//  FavoritesViewController.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import UIKit

final class FavoritesViewController: UIViewController {
	private let output: FavoritesViewOutput
    private let imageLoader: ImageLoaderProtocol
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    private let searchController = UISearchController()
    
    private var viewModels: [StockCardViewModel] = []
    private var filteredViewModels: [StockCardViewModel] = []
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
      }
    
    private var isFiltered: Bool {
        return !isSearchBarEmpty && searchController.isActive
    }


    init(output: FavoritesViewOutput, imageLoader: ImageLoaderProtocol) {
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
    
    private func setup() {
        setupCollectionView()
        setupSearch()
    }
    
    private func setupSearch() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        
        definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = Constants.backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StockCardCell.self, forCellWithReuseIdentifier: StockCardCell.identifier)
        collectionView.register(FooterLoaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoaderView.identifier)
    }
    
    private func setupConstraints() {
        [collectionView].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - FavoritesViewInput

extension FavoritesViewController: FavoritesViewInput {
    func updateFiltered(with viewModels: [StockCardViewModel]) {
        self.filteredViewModels = viewModels
        collectionView.reloadData()
    }
    
    func update(with viewModels: [StockCardViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
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
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltered ? filteredViewModels.count : viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockCardCell.identifier, for: indexPath) as? StockCardCell else {
            return UICollectionViewCell()
        }
        let viewModel: StockCardViewModel
        if isFiltered {
            viewModel = filteredViewModels[indexPath.item]
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
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel: StockCardViewModel
        if isFiltered {
            viewModel = filteredViewModels[indexPath.item]
        } else {
            viewModel = viewModels[indexPath.item]
        }
        output.onTapStock(viewModel)
    }
}

// MARK: - StockCardDelegate

extension FavoritesViewController: StockCardDelegate {
    func onTapFavorite(_ cell: StockCardCell, isFavorite: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
       
        let symbolToDelete: String
        if isFiltered {
            symbolToDelete = filteredViewModels[indexPath.item].symbol
            filteredViewModels.remove(at: indexPath.item)
            if let index = findViewModelIndex(viewModels, with: symbolToDelete) {
                viewModels.remove(at: index)
            }
            collectionView.deleteItems(at: [indexPath])
        } else {
            symbolToDelete = viewModels[indexPath.item].symbol
            viewModels.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
        
        output.onTapFavorite(with: symbolToDelete)
        
        NotificationCenter.default.post(
            name: .didChangeFavorite,
            object: self,
            userInfo: ["symbol": symbolToDelete]
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

// MARK: UISearchResultsUpdating

extension FavoritesViewController: UISearchResultsUpdating {
    private func filterContentForSearchText(searchText: String){
        output.filter(stonks: viewModels, with: searchText.lowercased())
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}

private extension FavoritesViewController {
    enum Constants {
        static let backgroundColor: UIColor = .white
        static let cellPadding: CGFloat = 32.0
        static let interItemSpacing: CGFloat = 8.0
        static let segmentHeight: CGFloat = 20.0
    }
}
