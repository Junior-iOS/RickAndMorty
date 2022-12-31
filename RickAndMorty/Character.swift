//
//  Character.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: CharacterGenerics
    let location: CharacterGenerics
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

enum CharacterGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case `unknown` = "unknown"
    
    var text: String {
        switch self {
        case .male, .female, .genderless:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

struct CharacterGenerics: Codable {
    let name: String
    let url: String
}
