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
    ///   - completion: Callback with data or error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
        
    }
}
