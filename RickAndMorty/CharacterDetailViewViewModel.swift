//
//  CharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 31/12/22.
//

import Foundation

final class CharacterDetailViewViewModel {
    private let character: Character
    public var title: String {
        character.name.uppercased()
    }
    
    init(character: Character) {
        self.character = character
    }
}
