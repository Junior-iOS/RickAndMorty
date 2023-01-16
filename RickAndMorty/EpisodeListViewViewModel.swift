//
//  EpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 14/01/23.
//

import Foundation
import UIKit

protocol EpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with indexPaths: [IndexPath])
    func didSelectEpisode(_ episode: Episode)
}

final class EpisodeListViewViewModel: NSObject {
    public weak var delegate: EpisodeListViewViewModelDelegate?
    
    public var episodes: [Episode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = CharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: systemColors.randomElement() ?? .systemBlue
                )
                
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [CharacterEpisodeCollectionViewCellViewModel] = []
    private var info: GetAllEpisodesResponse.Info?
    private var isLoadingMoreEpisodes = false
    private let systemColors: [UIColor] = [
        .systemBlue,
        .systemMint,
        .systemRed,
        .systemGreen,
        .systemOrange,
        .systemPurple,
        .systemPink,
        .systemYellow,
        .systemIndigo
    ]
    
    public var shouldShowLoadMoreIndicator: Bool {
        return info?.next != nil
    }
    
    /// Fetch initial set of characters (20)
    public func fetchEpisodes() {
        Service.shared.execute(.listEpisodesRequests, expecting: GetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                let results = model.results
                let info = model.info
                
                self?.info = info
                self?.episodes = results
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalEpisodes(with url: URL) {
        guard !isLoadingMoreEpisodes else { return }
        
        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        
        Service.shared.execute(request, expecting: GetAllEpisodesResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                let results = model.results
                let info = model.info
                self.info = info
                
                let originalCount = self.episodes.count
                let newCount = results.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPaths: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
                    return IndexPath(row: $0, section: 0)
                }
                
                self.episodes.append(contentsOf: results)
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreEpisodes(with: indexPaths)
                    self.isLoadingMoreEpisodes = false
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                self.isLoadingMoreEpisodes = false
            }
        }
    }
    
}

// MARK: - COLLECTIONVIEW DELEGATE
extension EpisodeListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectEpisode(episodes[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier,
                                                            for: indexPath) as? CharacterEpisodeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width - 20
        
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
            for: indexPath) as? FooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        return footer
    }
    
    // MARK: - SET FOOTER SIZE
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - SCROLLVIEW DELEGATE
extension EpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreEpisodes,
              !cellViewModels.isEmpty,
        let nextUrl = info?.next, let url = URL(string: nextUrl)
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let scrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (contentHeight - scrollViewFixedHeight - 120) { // 120 is the footer height size, with a 20 extra
                self?.fetchAdditionalEpisodes(with: url)
            }
            
            timer.invalidate()
        }
    }
}

