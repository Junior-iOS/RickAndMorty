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
                cellViewModels.append(viewModel)
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
    public func fetchAdditionalCharacters() {
        isLoadingMoreCharacters = true
        print("Loading more data!!!")
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
        guard kind == UICollectionView.elementKindSectionFooter else { fatalError("Unsupported") }
        guard let footer = collectionView.dequeueReusableSupplementaryView(
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
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters else { return }
        
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewFixedHeight = scrollView.frame.size.height
        
        print("OFFSET: ", offset)
        print("CONTENT HEIGHT: ", contentHeight)
        print("SCROLL FIXED HEIGHT: ", scrollViewFixedHeight)
        print("")
        
        if offset >= (contentHeight - scrollViewFixedHeight - 120) { // 120 is the footer height size, with a 20 extra
            fetchAdditionalCharacters()
        }
    }
}
