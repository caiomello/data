//
//  NetworkingService.swift
//  Services
//
//  Created by Caio Mello on 7/18/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case connectionError
    case noData
}

public struct NetworkingService {
    private let session: URLSession
    private let loggingEnabled: Bool

    public init(session: URLSession = .shared, loggingEnabled: Bool = true) {
        self.session = session
        self.loggingEnabled = loggingEnabled
    }

    @discardableResult public func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        let request = URLRequest(endpoint: endpoint)

        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                if error != nil { throw NetworkingError.connectionError }

                guard let data = data else { throw NetworkingError.noData }

                let object = try decoder.decode(T.self, from: data)

                self.log(request: request, type: .success)

                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                self.log(request: request, type: .failure(error))

                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        log(request: request, type: .requestFired)

        task.resume()

        return task
    }

    @discardableResult public func requestManagedObject<T: Decodable>(_ type: T.Type, endpoint: Endpoint, decoder: JSONDecoder, completion: @escaping (Result<Void?, Error>) -> Void) -> URLSessionDataTask? {
        let request = URLRequest(endpoint: endpoint)

        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                if error != nil { throw NetworkingError.connectionError }

                guard let data = data else { throw NetworkingError.noData }

                let _ = try decoder.decode(T.self, from: data)

                guard let managedObjectContext = decoder.managedObjectContext() else {
                    fatalError("Decoding failed - No managed object context")
                }

                try managedObjectContext.save()

                self.log(request: request, type: .success)

                DispatchQueue.main.async {
                    completion(.success(nil))
                }
            } catch {
                self.log(request: request, type: .failure(error))

                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        log(request: request, type: .requestFired)

        task.resume()

        return task
    }
}

// MARK: - Logging

extension NetworkingService {
    private enum LoggingType {
        case requestFired
        case success
        case failure(Error)
    }

    // swiftlint:disable localizable_strings
    private func log(request: URLRequest, type: LoggingType) {
        if isDebug() {
            return
        }

        let log = "[\(request.httpMethod!)] \(request.url!.absoluteString)"

        switch type {
        case .requestFired:
            print(log)
        case .success:
            print("\(log) - Success")
        case .failure(let error):
            print("\(log) - Failure: \(error)")
        }
    }

    private func isDebug() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
