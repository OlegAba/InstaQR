//
//  LoadingNotificationViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class LoadingNotificationViewController: NotificationViewController {
    
    // MARK: - Internal Properties
    
    var message: String? {
        didSet { titleLabel.text = message }
    }
    
    // MARK: - Private Properties
    
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .label
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupContentView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupContentView() {
        contentView.layer.cornerRadius = 5.0
        contentView.addSubview(activityIndicatorView)
        contentView.addSubview(titleLabel)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        let inset: CGFloat = 10.0
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 45.0),
            
            activityIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: activityIndicatorView.trailingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
        ])
    }
}
