//
//  EpisodeViewController.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import UIKit

final class EpisodeViewController: UIViewController {

    private let episodeListView = EpisodeListView()

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

extension EpisodeViewController: CodeView {
    func buildHierarchy() {
        view.addSubview(episodeListView)
    }
    
    func setupConstraints() {
        episodeListView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 left: view.safeAreaLayoutGuide.leftAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .systemBackground
        title = "Episodes"
        episodeListView.delegate = self
    }
}

extension EpisodeViewController: EpisodeListViewDelegate {
    func setEpisodeListView(with characterListView: EpisodeListView, didSelectEpisode episode: Episode) {
        let vc = EpisodeDetailViewController(url: URL(string: episode.url))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
