//
//  TableViewCell.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 3
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
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
    
    func setupViews() {
        backgroundColor = .systemGray6
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(seperatorLineView)
    }
    
    // MARK: - Layout
    
    func layoutViews() {
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 17.0),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            seperatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            seperatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            seperatorLineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            seperatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
}
