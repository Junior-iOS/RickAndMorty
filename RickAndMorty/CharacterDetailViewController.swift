//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Junior Silva on 31/12/22.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    private var viewModel: CharacterDetailViewViewModel?
    private let characaterDetailView: CharacterDetailView

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    init(viewModel: CharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.characaterDetailView = CharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.characaterDetailView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapShare() {
        
    }
    
}

// MARK: - CODE VIEW
extension CharacterDetailViewController: CodeView {
    func buildHierarchy() {
        view.addSubview(characaterDetailView)
    }
    
    func setupConstraints() {
        characaterDetailView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                    left: view.safeAreaLayoutGuide.leftAnchor,
                                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .systemBackground
        title = viewModel?.title
        
        characaterDetailView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
}

extension CharacterDetailViewController: CharacterDetailViewDelegate {
    func didTapEpisodes(_ selection: String) {
        let vc = EpisodeDetailViewController(url: URL(string: selection))
        navigationController?.pushViewController(vc, animated: true)
    }
}
