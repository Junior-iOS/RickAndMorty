//
//  CharactersCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Junior Silva on 29/12/22.
//

import UIKit

class CharactersCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharactersCollectionViewCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let lblName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let lblStatus: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: CharacterCollectionViewCellViewModel) {
        lblName.text = viewModel.characterName
        lblStatus.text = viewModel.characterStatusText
        
        viewModel.fetch { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        lblName.text = nil
        lblStatus.text = nil
    }
}

extension CharactersCollectionViewCell: CodeView {
    func buildHierarchy() {
        contentView.addSubviews(imageView, lblName, lblStatus)
    }
    
    func setupConstraints() {
        imageView.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         bottom: lblName.topAnchor,
                         paddingBottom: 3,
                         right: contentView.rightAnchor)
        
        lblName.anchor(top: imageView.bottomAnchor,
                       paddingTop: 3,
                       left: contentView.leftAnchor,
                       paddingLeft: 5,
                       bottom: lblStatus.topAnchor,
                       paddingBottom: 3,
                       right: contentView.rightAnchor,
                       paddingRight: 5,
                       height: 40)
        
        lblStatus.anchor(left: contentView.leftAnchor,
                         paddingLeft: 5,
                         bottom: contentView.bottomAnchor,
                         paddingBottom: 5,
                         right: contentView.rightAnchor,
                         paddingRight: 5,
                         height: 40)
    }
    
    func setupAdditionalConfiguration() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
}
