//
//  SpringBoardResources.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 10.04.23.
//

import Foundation

struct SpringBoardResources {
    // MARK: - States
    enum State {
        case onStartFetchingImages
        case onStopFetchingImages
        case onFetchAllImages([Data])
        case onFetchOneImage(Data)
    }

    enum Constants {
        enum UI {
            static let nivagationBarTitle: String = "SpringBoard"
        }

        enum Mocks {
            static let totalPhotosCountRange: Range = 0..<140
        }
    }
}
