//
//  PermissionHandlerView.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class PermissionHandlerView: UIView {
    
    // MARK: - Internal Properties
    
    enum PermissionType {
        case cameraUsage
        case photoLibraryUsage
    }
    
    enum ButtonType {
        case access
        case settings
    }
    
    var permissionType: PermissionType? {
        didSet {
            switch permissionType {
            case .cameraUsage:
                titleLabel.text = "Capture Videos"
                descriptionLabel.text = "Allow \(System.shared.appName) access to your camera to scan barcodes"
            case .photoLibraryUsage:
                titleLabel.text = "Save Live Wallpaper"
                descriptionLabel.text = "Allow \(System.shared.appName) access to your photo library to save your live wallpaper"
            default:
                break
            }
        }
    }
    
    var buttonType: ButtonType? {
        didSet {
            switch buttonType {
            case .access:
                primaryButton.setTitle("Enable Access", for: .normal)
            case .settings:
                primaryButton.setTitle("Go to Settings", for: .normal)
                primaryButton.removeTarget(nil, action: nil, for: .allEvents)
                primaryButton.addTarget(self, action: #selector(settingsButtonWasTapped), for: .touchUpInside)
            default:
                break
            }
        }
    }
    
    // MARK: - Private Properties
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var labelContainerView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var primaryButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        return primaryButton
    }()
    
    // MARK: - Lifetime
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(labelContainerView)
        addSubview(primaryButton)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            primaryButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            labelContainerView.topAnchor.constraint(equalTo: topAnchor),
            labelContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelContainerView.bottomAnchor.constraint(equalTo: primaryButton.topAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: labelContainerView.centerYAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10.0),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc fileprivate func settingsButtonWasTapped() {
        System.shared.openAppSettingsUrl()
    }
    
    // MARK: - Internal Methods
    
    func addAccessButtonTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        primaryButton.addTarget(target, action: action, for: event)
    }
}
