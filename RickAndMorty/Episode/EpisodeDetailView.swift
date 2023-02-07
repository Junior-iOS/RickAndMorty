//
//  EpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Junior Silva on 14/01/23.
//

import UIKit

final class EpisodeDetailView: UIView {
    
    private var viewModel: EpisodeDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.color = .systemOrange
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: EpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(100)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension EpisodeDetailView: CodeView {
    func buildHierarchy() {
        let collectionView = createCollectionView()
        addSubviews(collectionView, spinner)
        self.collectionView = collectionView
    }

    func setupConstraints() {
        guard let collectionView = collectionView else { return }

        spinner.center(inView: self)
        spinner.setDimensions(height: 100, width: 100)

        collectionView.anchor(top: topAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor)
    }

    func setupAdditionalConfiguration() {}
}

extension EpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemYellow
        return cell
    }
}
