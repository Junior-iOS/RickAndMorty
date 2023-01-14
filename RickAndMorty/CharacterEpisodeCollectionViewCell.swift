//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Junior Silva on 13/01/23.
//

import UIKit

class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharacterEpisodeCollectionViewCell"
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    public func configure(with viewModel: CharacterEpisodeCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            guard let self = self else { return }
            self.seasonLabel.text = "Episode: \(data.episode)"
            self.nameLabel.text = data.name
            self.airDateLabel.text = "Aired on \(data.airDate)"
        }
        viewModel.fetchEpisode()
    }
}

extension CharacterEpisodeCollectionViewCell: CodeView {
    func buildHierarchy() {
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
    }
    
    func setupConstraints() {
        seasonLabel.anchor(top: contentView.topAnchor,
                           left: contentView.leftAnchor,
                           paddingLeft: 10,
                           bottom: contentView.bottomAnchor,
                           paddingBottom: 10,
                           right: contentView.rightAnchor,
                           paddingRight: 10)
        
        nameLabel.anchor(top: seasonLabel.bottomAnchor,
                           left: contentView.leftAnchor,
                           paddingLeft: 10,
                           right: contentView.rightAnchor,
                           paddingRight: 10)
        
        airDateLabel.anchor(top: nameLabel.bottomAnchor,
                           left: contentView.leftAnchor,
                           paddingLeft: 10,
                           right: contentView.rightAnchor,
                           paddingRight: 10)
        
        NSLayoutConstraint.activate([
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33)
        ])
    }
    
    func setupAdditionalConfiguration() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 9
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
    }
}
