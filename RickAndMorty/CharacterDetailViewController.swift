//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Junior Silva on 31/12/22.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    var viewModel: CharacterDetailViewViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = viewModel?.title
    }
    
    init(viewModel: CharacterDetailViewViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
