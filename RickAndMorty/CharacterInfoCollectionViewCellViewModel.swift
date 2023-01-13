//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 13/01/23.
//

import Foundation

final class CharacterInfoCollectionViewCellViewModel {
    
    public let value: String
    public let title: String
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
    
}
