//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import UIKit

final class CharacterViewController: UIViewController {
    
    private let characterListView = CharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

}

extension CharacterViewController: CodeView {
    func buildHierarchy() {
        view.addSubview(characterListView)
    }
    
    func setupConstraints() {
        characterListView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 left: view.safeAreaLayoutGuide.leftAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .systemBackground
        title = "Characters"
    }
}
