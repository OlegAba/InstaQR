//
//  PopUpNotificationViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class PopUpNotificationViewController: NotificationViewController {
    
    // MARK: - Internal Properties
    
    var titleText: String? {
        didSet { titleLabel.text = titleText }
    }
    
    var messageText: String? {
           didSet { messageLabel.text = messageText }
    }
    
    lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inset: CGFloat = 10.0
    
    // MARK: - Private Properties
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        contentView.alpha = 0
        contentView.isHidden = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(buttonContainerView)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset * 1.5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset * 2.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset * 2.0),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset * 1),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset * 2.0),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset * 2.0),
            
            buttonContainerView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: inset * 2.0),
            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            
            contentView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: inset)
        ])
    }
    
    // MARK: - Internal Methods
    
    fileprivate func animatePresentViews() {
        System.shared.triggerFeedbackGenerator()
        
        contentView.isHidden = false
        contentView.alpha = 1.0
        contentView.transform = contentView.transform.scaledBy(x: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        })
    }
}
