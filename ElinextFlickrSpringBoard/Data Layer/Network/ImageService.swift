//
//  ImageService.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 10.04.23.
//

import UIKit

protocol ImageServiceProtocol {
    func fetchImageData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void)
}

class ImageService: ImageServiceProtocol {

    private var networkService: NetworkServiceProtocol
    private var imageCache = NSCache<NSURL, NSData>()

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchImageData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        if let cachedImageData = imageCache.object(forKey: url as NSURL) {
            completion(.success(cachedImageData as Data))
            return
        }

        networkService.fetchData(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageCache.setObject(data as NSData, forKey: url as NSURL)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
