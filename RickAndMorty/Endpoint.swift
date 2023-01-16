//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import Foundation

@frozen enum Endpoint: String, Hashable, CaseIterable {
    case character
    case location
    case episode
}
