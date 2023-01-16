//
//  EpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 14/01/23.
//

import Foundation

final class EpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else { return }
        
        Service.shared.execute(request, expecting: Episode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                break
            }
        }
    }
}
