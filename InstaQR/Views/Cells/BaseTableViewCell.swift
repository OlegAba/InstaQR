//
//  BaseTableViewCell.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    var logoImage: UIImage? {
        didSet { logoImageView.image = logoImage }
    }
    
    var logoImageBackgroundColor: UIColor? {
        didSet { logoImageView.backgroundColor = logoImageBackgroundColor }
    }
    
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var isLast = false {
        didSet { seperatorLineView.isHidden = isLast }
    }
    
    var iconImage: UIImage? {
        didSet { iconImageView.image = iconImage }
    }
    
    var iconColor: UIColor? {
        didSet { iconImageView.tintColor = iconColor }
    }
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .placeholderText
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        backgroundColor = .systemGray6
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(seperatorLineView)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 15.0),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10.0),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 17.0),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            seperatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            seperatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            seperatorLineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            seperatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
