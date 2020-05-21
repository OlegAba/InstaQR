//
//  ButtonsPopUpNotificationViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

protocol ButtonsPopUpNotificationDelegate {
    func primaryButtonWasTapped(for buttonsPopUpNotificationViewController: ButtonsPopUpNotificationViewController)
    func secondaryButtonWasTapped(for buttonsPopUpNotificationViewController: ButtonsPopUpNotificationViewController)
}

class ButtonsPopUpNotificationViewController: PopUpNotificationViewController {
    
    // MARK: - Internal Properties
    
    // MARK: - Internal Properties
    
    var delegate: ButtonsPopUpNotificationDelegate!
    
    lazy var primaryButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        primaryButton.addTarget(self, action: #selector(primaryButtonWasTapped), for: .touchUpInside)
        return primaryButton
    }()
    
    lazy var secondaryButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        primaryButton.backgroundColor = nil
        primaryButton.addTarget(self, action: #selector(secondaryButtonWasTapped), for: .touchUpInside)
        return primaryButton
    }()
    
    // MARK: - Private Properties
    
    fileprivate lazy var backgroundTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(secondaryButtonWasTapped))
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        view.addGestureRecognizer(backgroundTapGesture)
        buttonContainerView.addSubview(primaryButton)
        buttonContainerView.addSubview(secondaryButton)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            secondaryButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            secondaryButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            secondaryButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            secondaryButton.trailingAnchor.constraint(equalTo: buttonContainerView.centerXAnchor, constant: -(inset / 2.0)),
            
            primaryButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            primaryButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            primaryButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            primaryButton.leadingAnchor.constraint(equalTo: buttonContainerView.centerXAnchor, constant: (inset / 2.0))
        ])
    }
    
    // MARK: - Actions
    
    @objc private func secondaryButtonWasTapped() {
        delegate.secondaryButtonWasTapped(for: self)
    }
    
    @objc private func primaryButtonWasTapped() {
        delegate.primaryButtonWasTapped(for: self)
    }
}
