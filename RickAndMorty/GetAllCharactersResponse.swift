//
//  GetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Junior Silva on 29/12/22.
//

import Foundation

struct GetAllCharactersResponse: Codable {
    let info: Info
    let results: [Character]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
