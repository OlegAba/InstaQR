//
//  CropWallpaperViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import CropViewController

protocol CropWallpaperDelegate {
    func cropWallpaper(_ cropWallpaperViewController: CropWallpaperViewController, didCropToImage image: UIImage)
}

class CropWallpaperViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    var imageToCrop: UIImage!
    var delegate: CropWallpaperDelegate!
    
    // MARK: - Private Properties
    
    fileprivate lazy var cropViewController: CropViewController = {
        let cropViewController = CropViewController(image: imageToCrop)
        cropViewController.delegate = self
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.customAspectRatio = UIScreen.main.bounds.size
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        cropViewController.cancelButtonColor = .systemRed
        cropViewController.doneButtonColor = .systemBlue
        cropViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // NOTE: Remove default UIVisualEffectView blur subview
        cropViewController.cropView.subviews[2].removeFromSuperview()
        
        // NOTE: Add custom VisualEffectView blur subview
        cropViewController.cropView.subviews[1].addSubview(blurEffectView)
        
        return cropViewController
    }()
    
    fileprivate lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // NOTE: Prevent memory leak bug
        cropViewController.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // NOTE: Reassign delegate that is set to nil during viewDidDisappear
        cropViewController.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        view.backgroundColor = .systemBackground
        addChild(cropViewController)
        view.addSubview(cropViewController.view)
        cropViewController.didMove(toParent: self)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            cropViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            cropViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cropViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cropViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: cropViewController.toolbar.topAnchor)
        ])
    }
}

// MARK: - CropViewControllerDelegate
extension CropWallpaperViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        let resizedImage = image.resized(size: UIScreen.main.nativeBounds.size)
        
        self.delegate.cropWallpaper(self, didCropToImage: resizedImage)
    }
}
