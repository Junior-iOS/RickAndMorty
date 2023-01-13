//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Junior Silva on 31/12/22.
//

import Foundation
import UIKit

final class CharacterDetailView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: CharacterPhotoCollectionViewCell.identifier)
        collectionView.register(CharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: CharacterInfoCollectionViewCell.identifier)
        collectionView.register(CharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier)
        
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let viewModel: CharacterDetailViewViewModel
    
    init(frame: CGRect, viewModel: CharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSection(for index: Int) -> NSCollectionLayoutSection {
        let sectionType = viewModel.sections
        switch sectionType[index] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInfoSectionLayout()
        case .episodes:
            return viewModel.createEpisodesSectionLayout()
        }
    }
}

// MARK: - COLLECTIONVIEW DELEGATE/DATASOURCE
extension CharacterDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterPhotoCollectionViewCell.identifier,
                for: indexPath) as? CharacterPhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterInfoCollectionViewCell.identifier,
                for: indexPath) as? CharacterInfoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier,
                for: indexPath) as? CharacterEpisodeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
}

// MARK: - CODE VIEW
extension CharacterDetailView: CodeView {
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
        backgroundColor = .systemRed
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
