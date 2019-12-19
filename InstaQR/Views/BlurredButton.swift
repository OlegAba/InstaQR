//
//  BlurredButton.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class BlurredButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            blurEffectView.alpha = isHighlighted ? 0.8 : 1.0
        }
    }
    
    fileprivate lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    // MARK: - Lifetime
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.label, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        imageView?.tintColor = .label
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 35.0 / 2.0
        clipsToBounds = true
        
        insertSubview(blurEffectView, at: 0)
        
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 35.0),
            
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
