//
//  SpringBoardViewModel.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 10.04.23.
//

import Foundation

protocol SpringBoardViewModelProtocol {
    var onStateChange: ((SpringBoardResources.State) -> Void)? { get set }

    func fetchAllImagesData()
    func fetchOneImageData()
    func launch()
}

final class SpringBoardViewModel: SpringBoardViewModelProtocol {

    typealias Constants = SpringBoardResources.Constants.Mocks

    private let imageService: ImageServiceProtocol
    private var imagesData: [Data] = []

    var onStateChange: ((SpringBoardResources.State) -> Void)?

    // MARK: - Init
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }

    // MARK: - Public methods
    func launch() {
        fetchAllImagesData()
    }

    func fetchOneImageData() {
        imageService.fetchImageData(url: Request.uniqueURL) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imagesData.append(data)
                DispatchQueue.main.async {
                    self?.onStateChange?(.onFetchOneImage(data))
                }
            case .failure(let error):
                print("Error while fetching one image data: ", error)
            }
        }
    }

    func fetchAllImagesData() {
        onStateChange?(.onStartFetchingImages)
        imagesData.removeAll(keepingCapacity: true)

        let group = DispatchGroup()

        for _ in Constants.totalPhotosCountRange {
            group.enter()
            imageService.fetchImageData(url: Request.uniqueURL) { [weak self] result in
            defer { group.leave() }

                switch result {
                case .success(let data):
                    self?.imagesData.append(data)
                case .failure(let error):
                    print("Error while fetching all images' data: ", error.localizedDescription)
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.onStateChange?(.onFetchAllImages(self.imagesData))
            self.onStateChange?(.onStopFetchingImages)
        }
    }
}
