//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Junior Silva on 29/12/22.
//

import UIKit

protocol CharacterListViewDelegate: AnyObject {
    func setCharacterListView(with characterListView: CharacterListView, _ didSelectCharacter: Character)
}

class CharacterListView: UIView {
    
    private let viewModel = CharacterListViewViewModel()
    public weak var delegate: CharacterListViewDelegate?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharactersCollectionViewCell.self, forCellWithReuseIdentifier: CharactersCollectionViewCell.identifier)
        collectionView.register(FooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterLoadingCollectionReusableView.identifier)
        collectionView.isHidden = true
        collectionView.alpha = 0
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CharacterListView: CodeView {
    func buildHierarchy() {
        addSubviews(collectionView, spinner)
    }
    
    func setupConstraints() {
        spinner.center(inView: self)
        spinner.setDimensions(height: 100, width: 100)
        
        collectionView.anchor(top: topAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor)
    }
    
    func setupAdditionalConfiguration() {
        translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        viewModel.delegate = self
        viewModel.fetchCharacters()
        setupCollectionView()
    }
}

extension CharacterListView: CharacterListViewViewModelDelegate {
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            UIView.animate(withDuration: 0.4) {
                self.collectionView.alpha = 1
            }
        })
    }
    
    func didLoadMoreCharacters(with indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: indexPaths)
        }
    }
    
    func didSelectCharacter(_ character: Character) {
        delegate?.setCharacterListView(with: self, character)
    }
}
