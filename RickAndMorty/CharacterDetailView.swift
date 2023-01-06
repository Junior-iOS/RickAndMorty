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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        switch section {
        case 1:
            return 8
        case 2:
            return 10
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.backgroundColor = .yellow
        } else if indexPath.section == 1 {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .brown
        }
        
        return cell
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
