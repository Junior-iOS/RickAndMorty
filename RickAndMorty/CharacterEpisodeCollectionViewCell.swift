//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Junior Silva on 13/01/23.
//

import UIKit

class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharacterEpisodeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
    }
    
    public func configure(with viewModel: CharacterEpisodeCollectionViewCellViewModel) {
        
    }
}
