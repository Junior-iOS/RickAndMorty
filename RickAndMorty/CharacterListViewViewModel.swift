//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 29/12/22.
//

import Foundation
import UIKit

protocol CharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with indexPaths: [IndexPath])
    func didSelectCharacter(_ character: Character)
}

final class CharacterListViewViewModel: NSObject {
    public weak var delegate: CharacterListViewViewModelDelegate?
    
    public var characters: [Character] = [] {
        didSet {
            for character in characters {
                let viewModel = CharacterCollectionViewCellViewModel(characterName: character.name,
                                                                     characterStatus: character.status,
                                                                     characterImageUrl: URL(string: character.image)
                )
                
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [CharacterCollectionViewCellViewModel] = []
    private var info: GetAllCharactersResponse.Info?
    private var isLoadingMoreCharacters = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return info?.next != nil
    }
    
    /// Fetch initial set of characters (20)
    public func fetchCharacters() {
        Service.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                let results = model.results
                let info = model.info
                
                self?.info = info
                self?.characters = results
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(with url: URL) {
        guard !isLoadingMoreCharacters else { return }
        
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        Service.shared.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                let results = model.results
                let info = model.info
                self.info = info
                
                let originalCount = self.characters.count
                let newCount = results.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPaths: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
                    return IndexPath(row: $0, section: 0)
                }
                
                self.characters.append(contentsOf: results)
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharacters(with: indexPaths)
                    self.isLoadingMoreCharacters = false
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                self.isLoadingMoreCharacters = false
            }
        }
    }
    
}

// MARK: - COLLECTIONVIEW DELEGATE
extension CharacterListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectCharacter(characters[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharactersCollectionViewCell.identifier,
                                                            for: indexPath) as? CharactersCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 1.5)
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
extension CharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters,
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
                self?.fetchAdditionalCharacters(with: url)
            }
            
            timer.invalidate()
        }
    }
}
