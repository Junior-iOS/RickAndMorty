//
//  CharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Junior Silva on 13/01/23.
//

import UIKit

class CharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharacterInfoCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        titleLabel.textColor = .label
        valueLabel.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = .label
    }
    
    public func configure(with viewModel: CharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
        
        switch valueLabel.text {
        case "Alive":
            iconImageView.image = UIImage(systemName: "waveform.path.ecg")
            iconImageView.tintColor = .systemGreen
            titleLabel.textColor = .systemGreen
        case "Dead":
            iconImageView.image = UIImage(systemName: "xmark.circle")
            iconImageView.tintColor = .systemRed
            titleLabel.textColor = .systemRed
        default:
            iconImageView.image = viewModel.iconImage
            iconImageView.tintColor = viewModel.tintColor
            titleLabel.textColor = viewModel.tintColor
        }
    }
}

extension CharacterInfoCollectionViewCell: CodeView {
    func buildHierarchy() {
        contentView.addSubviews(titleContainerView, valueLabel, iconImageView)
        titleContainerView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleContainerView.anchor(left: contentView.leftAnchor,
                                  bottom: contentView.bottomAnchor,
                                  right: contentView.rightAnchor)
        NSLayoutConstraint.activate([titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33)])
        
        titleLabel.anchor(top: titleContainerView.topAnchor,
                          left: titleContainerView.leftAnchor,
                          bottom: titleContainerView.bottomAnchor,
                          right: titleContainerView.rightAnchor)
        
        iconImageView.anchor(top: contentView.topAnchor,
                             paddingTop: 33,
                             left: contentView.leftAnchor,
                             paddingLeft: 15)
        iconImageView.setDimensions(height: 30, width: 30)
        
        valueLabel.anchor(left: iconImageView.rightAnchor,
                          paddingLeft: 10,
                          right: contentView.rightAnchor,
                          paddingRight: 10)
        valueLabel.centerY(inView: iconImageView)
    }
    
    func setupAdditionalConfiguration() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 9
        contentView.layer.masksToBounds = true
    }
}
