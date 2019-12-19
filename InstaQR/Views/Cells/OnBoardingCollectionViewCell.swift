//
//  OnBoardingCollectionViewCell.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import SwiftyGif

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    var sectionTitle: String? {
        didSet { sectionTitleLabel.text = sectionTitle }
    }
    
    var sectionSubtitle: String? {
        didSet { sectionSubtitleLabel.text = sectionSubtitle }
    }
    
    var gifName: String? {
        didSet {
            guard let gifName = gifName else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let gif = try UIImage(gifName: gifName)
                    DispatchQueue.main.async {
                        self.imageView.setGifImage(gif)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    fileprivate lazy var labelsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(labelsContainerView)
        labelsContainerView.addSubview(sectionTitleLabel)
        labelsContainerView.addSubview(sectionSubtitleLabel)
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func layoutViews() {
        let inset: CGFloat = 10.0
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3),
            
            labelsContainerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            labelsContainerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            labelsContainerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: (inset * 3.0)),
            labelsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            sectionTitleLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            sectionTitleLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
            
            sectionSubtitleLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            sectionSubtitleLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            sectionSubtitleLabel.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: inset / 2.0),
        ])
    }
    
    func startGif() {
        imageView.startAnimatingGif()
    }
    
    func stopGif() {
        imageView.stopAnimatingGif()
    }
}
