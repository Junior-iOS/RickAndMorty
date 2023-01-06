//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Junior Silva on 03/01/23.
//

import Foundation

final class ImageLoader {
    static let shared = ImageLoader()
    private var imageCache: NSCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func downloadImage(_ url: URL, completion: @escaping(Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        
        if let data = imageCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self.imageCache.setObject(value, forKey: key)
            
            completion(.success(data))
        }.resume()
    }
}
