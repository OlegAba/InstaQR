//
//  NewWallpaperTableViewCell.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class NewWallpaperTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal Properties
    
    var overlayImage: UIImage? {
        didSet {
            if overlayImage != nil {
                deviceWallpaperIconView.overlayIconImage = overlayImage?.withRenderingMode(.alwaysTemplate)
            } else {
                deviceWallpaperIconView.overlayIconImage = nil
            }
        }
    }
    
    var wallpaperImage: UIImage? {
        didSet { deviceWallpaperIconView.backgroundImage = wallpaperImage }
    }
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
            
            if subtitle != nil {
                NSLayoutConstraint.deactivate(hiddenSubtitleConstraints)
                NSLayoutConstraint.activate(visibleSubtitleConstraints)
            } else {
                NSLayoutConstraint.deactivate(visibleSubtitleConstraints)
                NSLayoutConstraint.activate(hiddenSubtitleConstraints)
            }
        }
    }
    
    lazy var deviceWallpaperIconView: DeviceWallpaperIconView = {
        let deviceWallpaperIconView = DeviceWallpaperIconView()
        deviceWallpaperIconView.translatesAutoresizingMaskIntoConstraints = false
        return deviceWallpaperIconView
    }()
    
    // MARK: - Private Properties
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Photo Library"
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var hiddenSubtitleConstraints: [NSLayoutConstraint] = {
        return [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 15.0),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10.0),
            
            subtitleLabel.topAnchor.constraint(equalTo: centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 15.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10.0),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 0.0)
        ]
    }()
    
    fileprivate lazy var visibleSubtitleConstraints: [NSLayoutConstraint] = {
        return [
            titleLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 15.0),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10.0),
            
            subtitleLabel.topAnchor.constraint(equalTo: centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 15.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10.0),
            subtitleLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor)
        ]
    }()
    
    // MARK: - Lifetime
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(deviceWallpaperIconView)
        addSubview(subtitleLabel)
    }
    
    fileprivate func layoutViews() {
        titleLabel.removeAllConstraints()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(hiddenSubtitleConstraints)
        
        let widthAspectRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        
        NSLayoutConstraint.activate([
            deviceWallpaperIconView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            deviceWallpaperIconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            deviceWallpaperIconView.widthAnchor.constraint(equalTo: deviceWallpaperIconView.heightAnchor, multiplier: widthAspectRatio),
            deviceWallpaperIconView.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor),
        ])
    }
    
    func set(viewModel: NewWallpaperViewModel) {
        wallpaperImage = viewModel.wallpaperImage
        overlayImage = viewModel.barcodeImage
        title = viewModel.title
        subtitle = viewModel.subtitle
        iconImage = viewModel.iconImage
        iconColor = viewModel.iconColor
    }
    
    func animateRequiredBorder() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.systemRed.cgColor
        }) { (_) in
            UIView.transition(with: self, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.layer.borderWidth = 0.0
                self.layer.borderColor = nil
            })
        }
    }
}
