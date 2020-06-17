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
    var imageCropViewLastOriginX: CGFloat?
    
    // MARK: - Private Properties
    
    fileprivate lazy var cropViewController: CropViewController = {
        let cropViewController = CropViewController(image: imageToCrop)
        cropViewController.delegate = self
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.customAspectRatio = UIScreen.main.bounds.size
        cropViewController.toolbar.isHidden = true
        cropViewController.hidesNavigationBar = false
        cropViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // NOTE: Set TOCropViewControllers subviews to background color
        cropViewController.children[0].view.backgroundColor = view.backgroundColor
        cropViewController.cropView.backgroundColor = view.backgroundColor
        cropViewController.view.backgroundColor = view.backgroundColor
        
        // NOTE: Remove default UIVisualEffectView blur subview
        cropViewController.cropView.subviews[2].removeFromSuperview()
        
        // NOTE: Add custom VisualEffectView blur subview
        cropViewController.cropView.subviews[1].addSubview(blurredOverlayImageView)
        
        return cropViewController
    }()
    
    fileprivate lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    fileprivate lazy var blurredOverlayImageView: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = imageToCrop
        imageView.contentMode = .scaleToFill
        imageView.addSubview(blurEffectView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var donePrimaryButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // NOTE: Prevent memory leak bug
        cropViewController.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // NOTE: Save xOrigin of imageCropFrame to use in viewDidAppear
        imageCropViewLastOriginX = cropViewController.imageCropFrame.origin.x
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // NOTE: Reassign delegate that is set to nil during viewDidDisappear
        cropViewController.delegate = self
        
        // NOTE: Prevents bug where imageCropFrame offsets to the left when user begins back gesture on navBar and cancels
        if let xOrigin = imageCropViewLastOriginX {
            cropViewController.imageCropFrame.origin.x = xOrigin
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Crop to Screen Size"
        navigationItem.largeTitleDisplayMode = .never
        let rotateBarButtonItem = UIBarButtonItem(image: .rotateIcon, style: .plain, target: self, action: #selector(rotateButtonWasTapped))
        navigationItem.rightBarButtonItem = rotateBarButtonItem
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .systemBackground
        addChild(cropViewController)
        view.addSubview(cropViewController.view)
        cropViewController.didMove(toParent: self)
        view.addSubview(donePrimaryButton)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        let cropViewControllerToolbarHeight: CGFloat = cropViewController.toolbar.frame.height
        
        NSLayoutConstraint.activate([
            donePrimaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            donePrimaryButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            donePrimaryButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cropViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            cropViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cropViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cropViewController.view.bottomAnchor.constraint(equalTo: donePrimaryButton.topAnchor, constant: cropViewControllerToolbarHeight),
            
            blurredOverlayImageView.topAnchor.constraint(equalTo: view.topAnchor),
            blurredOverlayImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurredOverlayImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurredOverlayImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: blurredOverlayImageView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: blurredOverlayImageView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: blurredOverlayImageView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: blurredOverlayImageView.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc fileprivate func rotateButtonWasTapped() {
        cropViewController.toolbar.rotateClockwiseButton?.sendActions(for: .touchUpInside)
    }
    
    @objc fileprivate func doneButtonWasTapped() {
        cropViewController.toolbar.doneTextButton.sendActions(for: .touchUpInside)
    }
}

// MARK: - CropViewControllerDelegate
extension CropWallpaperViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        let resizedImage = image.resized(size: UIScreen.main.nativeBounds.size)
        
        self.delegate.cropWallpaper(self, didCropToImage: resizedImage)
    }
}
