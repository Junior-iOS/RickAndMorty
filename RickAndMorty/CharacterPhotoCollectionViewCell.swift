//
//  CharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Junior Silva on 13/01/23.
//

import UIKit

class CharacterPhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CharacterPhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 9
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    public func configure(with viewModel: CharacterPhotoCollectionViewCellViewModel) {
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension CharacterPhotoCollectionViewCell: CodeView {
    func buildHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor)
    }
    
    func setupAdditionalConfiguration() {}
}
