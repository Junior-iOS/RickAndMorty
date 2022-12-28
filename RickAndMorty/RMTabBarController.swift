//
//  RMTabBarController.swift
//  RickAndMorty
//
//  Created by Junior Silva on 28/12/22.
//

import UIKit

final class RMTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    private func setupTabs() {
        let charactersVC = CharacterViewController()
        let locationsVC = LocationViewController()
        let episodesVC = EpisodeViewController()
        let settingsVC = SettingsViewController()
        
        for vc in [charactersVC, locationsVC, episodesVC, settingsVC] {
            vc.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        let nav1 = UINavigationController(rootViewController: charactersVC)
        nav1.tabBarItem = UITabBarItem(title: "Character", image: UIImage(systemName: "person"), tag: 1)
        
        let nav2 = UINavigationController(rootViewController: locationsVC)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
        
        let nav3 = UINavigationController(rootViewController: episodesVC)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        
        let nav4 = UINavigationController(rootViewController: settingsVC)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }

}

