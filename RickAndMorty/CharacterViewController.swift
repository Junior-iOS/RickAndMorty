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
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let vc = SearchViewController(config: .init(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
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
        characterListView.delegate = self
    }
}

extension CharacterViewController: CharacterListViewDelegate {
    func setCharacterListView(with characterListView: CharacterListView, _ didSelectCharacter: Character) {
        let viewModel = CharacterDetailViewViewModel(character: didSelectCharacter)
        let vc = CharacterDetailViewController(viewModel: viewModel)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
