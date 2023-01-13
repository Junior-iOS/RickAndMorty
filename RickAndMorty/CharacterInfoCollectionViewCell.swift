//
//  CharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Junior Silva on 13/01/23.
//

import UIKit

class CharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharacterInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 9
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
    }
    
    public func configure(with viewModel: CharacterInfoCollectionViewCellViewModel) {
        
    }
}
