//
//  GetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Junior Silva on 16/01/23.
//

import Foundation

struct GetAllEpisodesResponse: Codable {
    let info: Info
    let results: [Episode]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
