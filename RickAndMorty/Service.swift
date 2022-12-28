//
//  Service.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import Foundation

final class Service {
    static let shared = Service()
    
    private init(){}
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
    }
}
