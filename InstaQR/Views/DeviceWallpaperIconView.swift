//
//  DeviceWallpaperIconView.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class DeviceWallpaperIconView: UIView {
    
    // MARK: - Internal Properties
    
    var backgroundImage: UIImage? {
        didSet { wallpaperImageView.image = backgroundImage }
    }
    
    var overlayIconImage: UIImage? {
        didSet {
            overlayIconImageView.image = overlayIconImage?.withRenderingMode(.alwaysTemplate)
            blurEffectView.isHidden = (overlayIconImage == nil)
            overlayIconImageView.isHidden = (overlayIconImage == nil)
        }
    }
    
    // MARK: - Private Properties
    
    fileprivate lazy var wallpaperImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray3
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isHidden = true
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    fileprivate lazy var overlayIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    func setupViews() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.5
        layer.cornerRadius = 5.0
        clipsToBounds = true
        
        addSubview(wallpaperImageView)
        addSubview(blurEffectView)
        addSubview(overlayIconImageView)
    }
    
    // MARK: - Layout
    
    func layoutViews() {
        
        NSLayoutConstraint.activate([
            
            wallpaperImageView.topAnchor.constraint(equalTo: topAnchor),
            wallpaperImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            wallpaperImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wallpaperImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: wallpaperImageView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: wallpaperImageView.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: wallpaperImageView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: wallpaperImageView.trailingAnchor),
            
            overlayIconImageView.widthAnchor.constraint(equalTo: wallpaperImageView.widthAnchor, multiplier: (0.7)),
            overlayIconImageView.heightAnchor.constraint(equalTo: overlayIconImageView.widthAnchor),
            overlayIconImageView.centerYAnchor.constraint(equalTo: wallpaperImageView.centerYAnchor),
            overlayIconImageView.centerXAnchor.constraint(equalTo: wallpaperImageView.centerXAnchor),
        ])
    }
}
