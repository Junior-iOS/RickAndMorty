//
//  CodeView.swift
//  RickAndMorty
//
//  Created by Junior Silva on 29/12/22.
//

import Foundation

protocol CodeView {
    func buildHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setup()
}

extension CodeView {
    func setup() {
        buildHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
