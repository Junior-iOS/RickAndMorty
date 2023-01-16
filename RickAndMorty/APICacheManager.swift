//
//  APICacheManager.swift
//  RickAndMorty
//
//  Created by Junior Silva on 14/01/23.
//

import Foundation

final class APICacheManager {
    
    private var cacheDictionary: [Endpoint: NSCache<NSString, NSData>] = [:]
    private var cache: NSCache = NSCache<NSString, NSData>()
    
    init() {
        setupCache()
    }
    
    private func setupCache() {
        Endpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
    
    public func cachedResponse(for endpoint: Endpoint, url: URL?) -> Data? {
        guard let cache = cacheDictionary[endpoint], let url = url else { return nil }
        
        let key = url.absoluteString as NSString
        return cache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: Endpoint, url: URL?, data: Data) {
        guard let cache = cacheDictionary[endpoint], let url = url else { return }
        
        let key = url.absoluteString as NSString
        cache.setObject(data as NSData, forKey: key)
    }
}
