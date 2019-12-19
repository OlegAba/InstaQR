//
//  AlertPopUpNotificationViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class AlertPopUpNotificationViewController: PopUpNotificationViewController {

    // MARK: - Internal Properties
    
    enum AlertType {
        case error
        case success
    }
    
    var alertType: AlertType? {
        didSet {
            switch alertType {
            case .error:
                titleText = "Error"
                okPrimaryButton.backgroundColor = .systemRed
            case .success:
                titleText = "Success"
                okPrimaryButton.backgroundColor = .systemGreen
            case .none:
                break
            }
        }
    }
    
    // MARK: - Private Properties
    
    fileprivate lazy var backgroundTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(okButtonWasTapped))
    }()
        
    fileprivate lazy var okPrimaryButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        primaryButton.setTitle("Ok", for: .normal)
        primaryButton.addTarget(self, action: #selector(okButtonWasTapped), for: .touchUpInside)
        return primaryButton
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(backgroundTapGesture)
        buttonContainerView.addSubview(okPrimaryButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            okPrimaryButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            okPrimaryButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            okPrimaryButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            okPrimaryButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
    }
    
    // MARK: - Actions
    
    @objc private func okButtonWasTapped() {
        dismiss(animated: true, completion: nil)
    }
}
