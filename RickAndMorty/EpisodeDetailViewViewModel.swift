//
//  EpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 14/01/23.
//

import Foundation

protocol EpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class EpisodeDetailViewViewModel {
    enum SectionType {
        case information(viewModels: [EpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [CharacterCollectionViewCellViewModel])
    }
    
    private let endpointUrl: URL?
    weak var delegate: EpisodeDetailViewViewModelDelegate?
    public private(set) var sections: [SectionType] = []
    
    private var dataTuple: (Episode, [Character])? {
        didSet {
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    public func fetchEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else { return }
        
        Service.shared.execute(request, expecting: Episode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(from: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(from episode: Episode) {
        let charactersOnEpisode: [URL] = episode.characters.compactMap({ return URL(string: $0) })
        let requests: [RMRequest] = charactersOnEpisode.compactMap({ return RMRequest(url: $0) })
        
        var characters: [Character] = []
        let group = DispatchGroup()
        
        for request in requests {
            group.enter()
            
            Service.shared.execute(request, expecting: Character.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }
    }
}
