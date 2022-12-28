//
//  Location.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import Foundation

struct Location: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
