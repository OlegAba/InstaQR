//
//  OnBoardingViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
 
class OnBoardingViewController: UIViewController {
    
    fileprivate lazy var containerPageViewController: ContainerPageViewController = {
        let containerPageViewController = ContainerPageViewController()
        containerPageViewController.pageSections = onBoardingPageSections
        containerPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return containerPageViewController
    }()
    
    fileprivate lazy var getStartedPrimaryButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Get Started", for: .normal)
        button.addTarget(self, action: #selector(getStartedButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(getStartedPrimaryButton)
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
            getStartedPrimaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            getStartedPrimaryButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            getStartedPrimaryButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            containerPageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerPageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerPageViewController.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            containerPageViewController.view.bottomAnchor.constraint(equalTo: getStartedPrimaryButton.topAnchor, constant: -view.layoutMargins.left),
        ])
    }
    
    @objc fileprivate func getStartedButtonWasTapped() {
        guard let newWallpaperNavigationController = System.shared.appDelegate().newWallpaperNavigationController else { return }
        newWallpaperNavigationController.modalPresentationStyle = .overFullScreen
        present(newWallpaperNavigationController, animated: true, completion: nil)
    }
}
