//
//  NetworkService.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 10.04.23.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void)
}

enum NetworkError: Error {
    case invalidUrl
    case invalidData
}

struct NetworkService: NetworkServiceProtocol {

    internal var session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func fetchData<T: Decodable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
