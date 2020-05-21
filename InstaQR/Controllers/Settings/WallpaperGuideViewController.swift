//
//  WallpaperGuideViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 5/21/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class WallpaperGuideViewController: ViewController {
    
    // MARK: - Private Properties
    
    fileprivate lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let navItem = UINavigationItem()
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonWasTapped))
        navItem.rightBarButtonItem = cancelBarButtonItem
        navigationBar.setItems([navItem], animated: false)
        return navigationBar
    }()
    
    fileprivate lazy var containerPageViewController: ContainerPageViewController = {
        let containerPageViewController = ContainerPageViewController()
        containerPageViewController.pageSections = wallpaperGuidePageSections
        containerPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return containerPageViewController
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        setupContainerPageViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupContainerPageViewController() {
        view.addSubview(containerPageViewController.view)
        addChild(containerPageViewController)
        containerPageViewController.didMove(toParent: self)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerPageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerPageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerPageViewController.view.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            containerPageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc fileprivate func cancelButtonWasTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
