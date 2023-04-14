//
//  SpringBoardCollectionViewCell.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 11.04.23.
//

import UIKit

final class SpringBoardCollectionViewCell: UICollectionViewCell {
    static var reuseID: String { String(describing: self) }

    // MARK: - Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 7.0
    }


    private let imageView: UIImageView = .init()
    private let activityIndicator: UIActivityIndicatorView = .init()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func didLoad() {
        setupItems()
    }

    // MARK: - Configure
    func configure(with imageData: Data?) {
        guard let imageData = imageData else { return }
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        self.imageView.image = UIImage(data: imageData)
    }
}

private extension SpringBoardCollectionViewCell {
    // MARK: - Private methods
    func setupItems() {
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true

        setupImageView()
        setupActivityIndicator()
    }

    func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.style = .medium
        activityIndicator.center = center

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension SpringBoardCollectionViewCell {
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
