//
//  SpringBoardCollectionView.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 11.04.23.
//

import UIKit

final class SpringBoardCollectionView: UIView {

    private enum Constants {
        static let numberOfColumns: CGFloat = 7
        static let numberOfRows: CGFloat = 10
        static let numberOfCellsPerPage: Int = Int(numberOfColumns * numberOfRows)

        static let horizontalSpacing: CGFloat = 2.0
        static let verticalSpacing: CGFloat = 1.0
        static let edgeInset: CGFloat = 5.0
    }

    private var collectionView: UICollectionView?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var imagesData: [Data] = []

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    func configure(with imagesData: [Data]) {
        self.imagesData.removeAll(keepingCapacity: true)
        self.imagesData = imagesData

        self.reloadCollectionWithAnimation()
    }

    func appendOneImage(with data: Data) {
        imagesData.append(data)
        collectionView?.reloadData()

        let section = Int(imagesData.count / Int(Constants.numberOfCellsPerPage))
        let item = imagesData.count - (section * Int(Constants.numberOfCellsPerPage)) - 1

        let indexPath = IndexPath(
            item: item,
            section: section
        )

        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
    }

    // MARK: - Public methods
    func didLoad() {
        setupItems()
    }

    func showActivityIndicator() {
        collectionView?.isHidden = true
        activityIndicator.startAnimating()
    }

    func hideActivityIndicator() {
        collectionView?.isHidden = false
        activityIndicator.stopAnimating()
    }
}

private extension SpringBoardCollectionView {
    // MARK: - Private methods
    func setupItems() {
        backgroundColor = .white

        setupCollectionView()
        setupActivityIndicator()
    }

    func setupLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.verticalSpacing
        layout.minimumLineSpacing = Constants.horizontalSpacing
        layout.sectionInset = .init(
            top: .zero,
            left: Constants.edgeInset,
            bottom: .zero,
            right: Constants.edgeInset
        )

        return layout
    }

    func setupCollectionView() {
        collectionView = .init(
            frame: .zero,
            collectionViewLayout: setupLayout()
        )

        guard let collectionView = collectionView else { return }

        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            SpringBoardCollectionViewCell.self,
            forCellWithReuseIdentifier: SpringBoardCollectionViewCell.reuseID
        )

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        activityIndicator.center = center
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    func reloadCollectionWithAnimation() {
        guard let collectionView = collectionView else { return }
        UIView.transition(
            with: collectionView,
            duration: 1.0,
            options: .transitionCrossDissolve,
            animations: { collectionView.reloadData() },
            completion: nil
        )
    }
}

extension SpringBoardCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil(Double(imagesData.count) / Double(Constants.numberOfCellsPerPage)))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfCellsPerPage
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SpringBoardCollectionViewCell.reuseID,
            for: indexPath
        ) as? SpringBoardCollectionViewCell else {
            return .init()
        }

        let indexForItem = indexPath.section * Int(Constants.numberOfCellsPerPage) + indexPath.item
        if indexForItem < imagesData.count {
            let imageData = imagesData[indexForItem]
            cell.configure(with: imageData)
        } else {
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
        }

        return cell
    }
}

extension SpringBoardCollectionView: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewFlowLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let horizontalSpacing = Constants.horizontalSpacing * (Constants.numberOfColumns - 1)
        let verticalSpacing = Constants.verticalSpacing * (Constants.numberOfRows - 1)

        let cellWidth = (bounds.width - horizontalSpacing - Constants.edgeInset * 2) / Constants.numberOfColumns
        let cellHeight = (bounds.height - verticalSpacing) / Constants.numberOfRows

        let size = CGSize(
            width: cellWidth,
            height: cellHeight
        )

        return size
    }
}
