//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 29/12/22.
//

import Foundation

final class CharacterCollectionViewCellViewModel: Hashable {
    public let characterName: String
    private let characterStatus: CharacterStatus
    private let characterImageUrl: URL?
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    init(characterName: String, characterStatus: CharacterStatus, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public func fetch(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        ImageLoader.shared.downloadImage(url, completion: completion)
    }
}

// MARK: - HASHABLE
extension CharacterCollectionViewCellViewModel: Equatable {
    static func == (lhs: CharacterCollectionViewCellViewModel, rhs: CharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}
