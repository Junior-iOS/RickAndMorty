//
//  Service.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import Foundation

final class Service {
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case failedParsingData
    }
    
    static let shared = Service()
    private let cacheManager = APICacheManager()
    
    private init(){}
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            print("Using cached API Response")
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            } catch {
                completion(.failure(ServiceError.failedParsingData))
            }
        }.resume()
    }
    
    private func request(from request: RMRequest) -> URLRequest? {
        guard let url = request.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        return urlRequest
    }
}
