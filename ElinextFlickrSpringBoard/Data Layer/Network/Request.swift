//
//  Request.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 10.04.23.
//

import Foundation

enum Request {
    private static let baseUrl: URL? = URL(string: "https://loremflickr.com/200/200")

    static var uniqueURL: URL? {
        guard let baseUrl = baseUrl else { return nil }
        let cacheBuster = UUID().uuidString
        return URL(string: "\(baseUrl.absoluteString)?random=\(cacheBuster)")
    }
}
