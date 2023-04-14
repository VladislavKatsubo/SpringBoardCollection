//
//  SpringBoardFactory.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 10.04.23.
//

import UIKit

final class SpringBoardFactory {
    func createController() -> UIViewController {
        let urlSession = URLSession(configuration: .default)
        let networkService = NetworkService(session: urlSession)
        let imageService = ImageService(networkService: networkService)
        let viewModel = SpringBoardViewModel(imageService: imageService)
        let viewController = SpringBoardViewController()

        viewController.configure(with: viewModel)

        return viewController
    }
}
