//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Junior Silva on 14/01/23.
//

import UIKit

final class EpisodeDetailViewController: UIViewController {
    private let viewModel: EpisodeDetailViewViewModel
    private let episodeDetailView = EpisodeDetailView()
    
    init(url: URL?) {
        self.viewModel = EpisodeDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    @objc private func didTapShare() {
        
    }
}

// MARK: - CODE VIEW
extension EpisodeDetailViewController: CodeView {
    func buildHierarchy() {
        view.addSubview(episodeDetailView)
    }
    
    func setupConstraints() {
        episodeDetailView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                    left: view.safeAreaLayoutGuide.leftAnchor,
                                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    func setupAdditionalConfiguration() {
        title = "Episode"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
}

extension EpisodeDetailViewController: EpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetails() {
        episodeDetailView.configure(with: viewModel)
    }
}
