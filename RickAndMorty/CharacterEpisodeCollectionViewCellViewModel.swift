//
//  CharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 13/01/23.
//

import UIKit

protocol EpisodeDataRender {
    var name: String { get }
    var episode: String { get }
    var airDate: String { get }
}

final class CharacterEpisodeCollectionViewCellViewModel {
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((EpisodeDataRender) -> Void)?
    public var borderColor: UIColor
    
    private var episode: Episode? {
        didSet {
            guard let model = episode else { return }
            dataBlock?(model)
        }
    }
    
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl,
              let request = RMRequest(url: url) else { return }
        isFetching = true
        
        Service.shared.execute(request, expecting: Episode.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    public func registerForData(_ block: @escaping (EpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
}

extension CharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: CharacterEpisodeCollectionViewCellViewModel, rhs: CharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
