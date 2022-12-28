//
//  Episode.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import Foundation

struct Episode: Codable /*, RMEpisodeDataRender*/ {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
        case created
    }
}
