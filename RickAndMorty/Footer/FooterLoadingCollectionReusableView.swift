//
//  FooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Junior Silva on 01/01/23.
//

import UIKit

final class FooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "FooterLoadingCollectionReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FooterLoadingCollectionReusableView: CodeView {
    func buildHierarchy() {
        addSubview(spinner)
    }
    
    func setupConstraints() {
        spinner.center(inView: self)
        spinner.setDimensions(height: 100, width: 100)
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
        spinner.startAnimating()
    }
}
