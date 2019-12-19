//
//  PreviewWallpaperViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import PhotosUI
import LPLivePhotoGenerator

class PreviewWallpaperViewController: UIViewController {
    
    var livePhoto: LPLivePhoto!
    
    fileprivate lazy var livePhotoPreviewView: PHLivePhotoView = {
        let phLivePhotoView = PHLivePhotoView()
        phLivePhotoView.livePhoto = livePhoto.phLivePhoto
        phLivePhotoView.translatesAutoresizingMaskIntoConstraints = false
        return phLivePhotoView
    }()
    
    fileprivate lazy var doneBlurredButton: BlurredButton = {
        let blurredButton = BlurredButton()
        blurredButton.setTitle("Done", for: .normal)
        blurredButton.addTarget(self, action: #selector(doneButtonWasTapped), for: .touchUpInside)
        return blurredButton
    }()
    
    fileprivate lazy var saveBlurredButton: BlurredButton = {
        let blurredButton = BlurredButton()
        blurredButton.setTitle("Save", for: .normal)
        blurredButton.addTarget(self, action: #selector(saveButtonWasTapped), for: .touchUpInside)
        return blurredButton
    }()
    
    fileprivate lazy var livePhotoBlurredButton: BlurredButton = {
        let blurredButton = BlurredButton()
        blurredButton.setImage(UIImage(systemName: "livephoto"), for: .normal)
        blurredButton.addTarget(self, action: #selector(livePhotoButtonWasTapped), for: .touchUpInside)
        return blurredButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(livePhotoPreviewView)
        view.addSubview(doneBlurredButton)
        view.addSubview(saveBlurredButton)
        view.addSubview(livePhotoBlurredButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        livePhotoPreviewView.startPlayback(with: .full)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            
            livePhotoPreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            livePhotoPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            livePhotoPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            livePhotoPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            doneBlurredButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
            doneBlurredButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.layoutMargins.left),
            doneBlurredButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.layoutMargins.left),
            
            saveBlurredButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
            saveBlurredButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.layoutMargins.right),
            saveBlurredButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.layoutMargins.right),
            
            livePhotoBlurredButton.widthAnchor.constraint(equalTo: livePhotoBlurredButton.heightAnchor),
            livePhotoBlurredButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.layoutMargins.right),
            livePhotoBlurredButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc fileprivate func doneButtonWasTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveButtonWasTapped() {
        let photoAlbumViewController = PhotoAlbumViewController()
        photoAlbumViewController.livePhoto = livePhoto
        photoAlbumViewController.delegate = self
        present(UINavigationController(rootViewController: photoAlbumViewController), animated: true, completion: nil)
    }
    
    @objc fileprivate func livePhotoButtonWasTapped() {
        livePhotoPreviewView.startPlayback(with: .full)
    }
    
}

extension PreviewWallpaperViewController: PhotoAlbumDelegate {
    
    func photoAlbum(_ photoAlbumViewController: PhotoAlbumViewController, didSelect album: PhotoAlbum) {
        let loadingNotificationViewController = LoadingNotificationViewController()
        loadingNotificationViewController.modalPresentationStyle = .overFullScreen
        loadingNotificationViewController.message = "Saving Live Wallpaper..."
        
        photoAlbumViewController.dismiss(animated: true) {
            
            self.present(loadingNotificationViewController, animated: true) {
                
                let albumSaveLocation = album.name == "All Photos" ? nil : album
                ImageManager.shared.saveLivePhoto(to: albumSaveLocation, imageURL: self.livePhoto.imageURL, videoURL: self.livePhoto.videoURL) { (saved: Bool) in
                    
                    DispatchQueue.main.async {
                        
                        loadingNotificationViewController.dismiss(animated: true) {
                            
                            let alertPopUpNotificationViewController = AlertPopUpNotificationViewController()
                            alertPopUpNotificationViewController.modalPresentationStyle = .overFullScreen
                            let albumName = album.name == "All Photos" ? "your Photo Library" : album.name
                            
                            if saved {
                                alertPopUpNotificationViewController.alertType = .success
                                alertPopUpNotificationViewController.messageText = "The image was successfully saved to \(albumName). Please remember to set the image as your lock screen wallpaper in the general settings"
                            } else {
                                alertPopUpNotificationViewController.alertType = .error
                                alertPopUpNotificationViewController.messageText = "There was an error saving the image to \(albumName). Please try again"
                            }
                            
                            self.present(alertPopUpNotificationViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
