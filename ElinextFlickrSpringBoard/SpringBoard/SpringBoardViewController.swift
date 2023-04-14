//
//  SpringBoardViewController.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 10.04.23.
//

import UIKit

final class SpringBoardViewController: UIViewController {

    typealias Constants = SpringBoardResources.Constants.UI
    private var viewModel: SpringBoardViewModelProtocol?

    private let collectionView = SpringBoardCollectionView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupItems()
        setupViewModel()
        setupNavigationBar()
    }

    // MARK: - Configure
    func configure(with viewModel: SpringBoardViewModelProtocol) {
        self.viewModel = viewModel
    }
}

private extension SpringBoardViewController {
    // MARK: - Private methods
    func setupViewModel() {
        viewModel?.onStateChange = { [weak self] state in
            guard let self = self else { return }

            switch state {
            case .onFetchAllImages(let imagesData):
                self.collectionView.configure(with: imagesData)
            case .onFetchOneImage(let imageData):
                self.collectionView.appendOneImage(with: imageData)
            case .onStartFetchingImages:
                self.navigationItem.rightBarButtonItems?.forEach({ $0.isEnabled = false })
                self.collectionView.showActivityIndicator()
            case .onStopFetchingImages:
                self.navigationItem.rightBarButtonItems?.forEach({ $0.isEnabled = true })
                self.collectionView.hideActivityIndicator()
            }
        }
        viewModel?.launch()
    }

    func setupItems() {
        view.backgroundColor = .white
        navigationItem.title = Constants.nivagationBarTitle

        setupCollectionView()
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupNavigationBar() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadImages))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(fetchOneImageData))
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
        navigationItem.rightBarButtonItems?.forEach({ $0.isEnabled = false })
    }

    @objc
    func reloadImages() {
        viewModel?.fetchAllImagesData()
    }

    @objc
    func fetchOneImageData() {
        viewModel?.fetchOneImageData()
    }
}
