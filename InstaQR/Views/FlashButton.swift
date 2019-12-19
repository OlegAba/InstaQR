//
//  FlashButton.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class FlashButton: UIButton {
    
    // MARK: - Internal Properties
    
    enum StateType {
        case on
        case off
    }
    
    var stateType: StateType = .off {
        didSet {
            switch stateType {
            case .on:
                backgroundColor = .white
                iconImageView.tintColor = .systemBlue
            case .off:
                backgroundColor = .systemBlue
                iconImageView.tintColor = .white
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            iconImageView.alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    // MARK: - Private Properties
    
    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bolt.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let length: CGFloat = 50.0
    
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
        backgroundColor = .systemBlue
        layer.cornerRadius = length / 2.0
        translatesAutoresizingMaskIntoConstraints = false
        //addSubview(blurEffectView)
        addSubview(iconImageView)
    }
    
    // MARK: - Layout
    fileprivate func layoutViews() {
        
        let inset: CGFloat = 12.5
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: length),
            widthAnchor.constraint(equalToConstant: length),
            
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
        ])
    }
}
