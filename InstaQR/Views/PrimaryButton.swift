//
//  PrimaryButton.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    
    // MARK: - Internal Properties
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? backgroundColor?.withAlphaComponent(0.8) : backgroundColor?.withAlphaComponent(1.0)
        }
    }
    
    var isLoading = false {
        didSet {
            if isLoading {
                titleHolder = currentTitle
                setTitle("", for: .normal)
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
                setTitle(titleHolder, for: .normal)
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet { backgroundColor = isEnabled ? .systemBlue : .systemGray5 }
    }
    
    // MARK: - Private Properties
    
    fileprivate var titleHolder: String?
    
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .white
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
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
        layer.cornerRadius = 10.0
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backgroundColor = .systemBlue
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.placeholderText, for: .disabled)
        addSubview(activityIndicatorView)
    }
    
    // MARK: - Layout
    func layoutViews() {
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50.0),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
