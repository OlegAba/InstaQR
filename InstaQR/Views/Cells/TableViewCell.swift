//
//  TableViewCell.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 4/14/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    var logoImageInset: UIEdgeInsets = .zero
    
    var logoImage: UIImage? {
        didSet {
            logoImageView.image = logoImage?.withAlignmentRectInsets(logoImageInset)
            logoImageBackgroundView.isHidden = (logoImage == nil)
        }
    }
    
    var logoImageBackgroundColor: UIColor? {
        didSet { logoImageBackgroundView.backgroundColor = logoImageBackgroundColor }
    }
    
    var title: String? {
        didSet { titleLabel.text = title }
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
    
    var isLast = false {
        didSet { separatorLineView.isHidden = isLast }
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var logoImageBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        view.isHidden = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        label.textAlignment = .left
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
    
    lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Private Properties
    
    fileprivate let insets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    
    fileprivate lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = layoutMargins.left
        stackView.addArrangedSubview(logoImageBackgroundView)
        stackView.addArrangedSubview(labelContainerView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    fileprivate lazy var labelContainerView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var hiddenSubtitleConstraints: [NSLayoutConstraint] = {
        return [
            titleLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: labelContainerView.centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 0.0)
        ]
    }()
    
    fileprivate lazy var visibleSubtitleConstraints: [NSLayoutConstraint] = {
        return [
            titleLabel.bottomAnchor.constraint(equalTo: labelContainerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: labelContainerView.centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
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
    
    override func layoutMarginsDidChange() {
        layoutMargins = insets
    }
    
    // MARK: - Setup
    
    func setupViews() {
        backgroundColor = .systemGray6
        layoutMargins = insets
        contentView.addSubview(iconImageView)
        contentView.addSubview(separatorLineView)
        contentView.addSubview(horizontalStackView)
    }
    
    // MARK: - Layout
    
    func layoutViews() {
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 17.0),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            
            horizontalStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -contentView.layoutMargins.right),
            
            
            logoImageBackgroundView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            logoImageBackgroundView.widthAnchor.constraint(equalTo: logoImageBackgroundView.heightAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: logoImageBackgroundView.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: logoImageBackgroundView.bottomAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: logoImageBackgroundView.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: logoImageBackgroundView.trailingAnchor),
            
            labelContainerView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLineView.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate(hiddenSubtitleConstraints)
    }
}
