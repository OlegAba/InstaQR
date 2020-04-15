//
//  WallpaperTableViewCell.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 4/14/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class WallpaperTableViewCell: TableViewCell {
    
    // MARK: - Internal Properties
    
    var overlayImage: UIImage? {
        didSet { deviceWallpaperIconView.overlayIconImage = overlayImage?.withRenderingMode(.alwaysTemplate) }
    }
    
    var wallpaperImage: UIImage? {
        didSet { deviceWallpaperIconView.backgroundImage = wallpaperImage }
    }
    
    lazy var deviceWallpaperIconView: DeviceWallpaperIconView = {
        let deviceWallpaperIconView = DeviceWallpaperIconView()
        deviceWallpaperIconView.translatesAutoresizingMaskIntoConstraints = false
        return deviceWallpaperIconView
    }()
    
    // MARK: - Setup
    
    override func setupViews() {
        super.setupViews()
        logoImage = UIImage()
        contentView.addSubview(deviceWallpaperIconView)
    }
    
    // MARK: - Layout
    
    override func layoutViews() {
        super.layoutViews()
        
        let widthAspectRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        
        NSLayoutConstraint.activate([
            deviceWallpaperIconView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            deviceWallpaperIconView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            deviceWallpaperIconView.widthAnchor.constraint(equalTo: deviceWallpaperIconView.heightAnchor, multiplier: widthAspectRatio),
            deviceWallpaperIconView.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor),
        ])
    }
    
    // MARK: - Internal Methods
    
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
