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
}

class ButtonsPopUpNotificationViewController: PopUpNotificationViewController {
    
    // MARK: - Internal Properties
    
    var delegate: ButtonsPopUpNotificationDelegate!
    
    // MARK: - Private Properties
    
    fileprivate lazy var backgroundTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(secondaryButtonWasTapped))
    }()
        
    fileprivate lazy var primaryButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        primaryButton.setTitle("Delete", for: .normal)
        primaryButton.backgroundColor = .systemRed
        primaryButton.addTarget(self, action: #selector(primaryButtonWasTapped), for: .touchUpInside)
        return primaryButton
    }()
    
    fileprivate lazy var secondaryButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        primaryButton.backgroundColor = nil
        primaryButton.setTitleColor(.systemRed, for: .normal)
        primaryButton.setTitle("Cancel", for: .normal)
        primaryButton.addTarget(self, action: #selector(secondaryButtonWasTapped), for: .touchUpInside)
        return primaryButton
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
        titleText = "Warning"
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func primaryButtonWasTapped() {
        delegate.primaryButtonWasTapped(for: self)
    }
}
