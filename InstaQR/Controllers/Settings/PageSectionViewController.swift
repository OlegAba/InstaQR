//
//  PageSectionViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import SwiftyGif
import MediaPlayer

class PageSectionViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    var pageIndex: Int = 0
    var inset: CGFloat = 0
    var gifName: String? = nil
    
    var placeholderImage: UIImage? {
        didSet { placeholderImageView.image = placeholderImage }
    }
    
    var sectionTitle: String? {
        didSet { sectionTitleLabel.text = sectionTitle }
    }
    
    var sectionSubtitle: String? {
        didSet { sectionSubtitleLabel.text = sectionSubtitle }
    }
    
    // MARK: - Private Properties
    
    fileprivate lazy var labelsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var sectionSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(placeholderImageView)
        view.addSubview(gifImageView)
        view.addSubview(labelsContainerView)
        labelsContainerView.addSubview(sectionTitleLabel)
        labelsContainerView.addSubview(sectionSubtitleLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gifImageView.startAnimatingGif()
        if gifImageView.gifImage != nil { return }
        setupGifImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gifImageView.stopAnimatingGif()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gifImageView.clear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/4),
            
            placeholderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderImageView.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/4),
            
            labelsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            labelsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            labelsContainerView.topAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: (inset * 2.0)),
            labelsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sectionTitleLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            sectionTitleLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
            
            sectionSubtitleLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            sectionSubtitleLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            sectionSubtitleLabel.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 5.0),
        ])
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupGifImage() {
        
        guard let gifName = gifName else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let gif = try UIImage(gifName: gifName)
                
                DispatchQueue.main.async {
                    self.gifImageView.setGifImage(gif)
                }
                
            } catch {
                print(error)
            }
        }
    }
}
