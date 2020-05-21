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

class PreviewWallpaperViewController: ViewController {
    
    // MARK: - Internal Properties
    
    var livePhoto: LPLivePhoto!
    
    // MARK: - Private Properties
    
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
    
    // MARK: - View Life Cycle
    
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
    
    // MARK: - Actions
    
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

// MARK: - PhotoAlbumDelegate
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
                            
                            let albumName = album.name == "All Photos" ? "your Photo Library" : album.name
                            self.presentPopUpNotificationViewController(for: saved, albumName: albumName)
                        }
                    }
                }
            }
        }
    }
    
    func presentPopUpNotificationViewController(for didSave: Bool, albumName: String) -> Void {
        
        if didSave {
            let buttonsPopUpNotificationViewController = ButtonsPopUpNotificationViewController()
            buttonsPopUpNotificationViewController.modalPresentationStyle = .overFullScreen
            buttonsPopUpNotificationViewController.titleText = "Success"
            buttonsPopUpNotificationViewController.messageText = "The image was successfully saved to \(albumName). Please remember to set the image as your lock screen wallpaper"
            buttonsPopUpNotificationViewController.primaryButton.setTitle("Ok", for: .normal)
            buttonsPopUpNotificationViewController.primaryButton.backgroundColor = .systemGreen
            buttonsPopUpNotificationViewController.secondaryButton.setTitle("Help?", for: .normal)
            buttonsPopUpNotificationViewController.secondaryButton.setTitleColor(.systemGreen, for: .normal)
            buttonsPopUpNotificationViewController.delegate = self
            present(buttonsPopUpNotificationViewController, animated: true, completion: nil)
        } else {
            let alertPopUpNotificationViewController = AlertPopUpNotificationViewController()
            alertPopUpNotificationViewController.modalPresentationStyle = .overFullScreen
            alertPopUpNotificationViewController.alertType = .error
            alertPopUpNotificationViewController.messageText = "There was an error saving the image to \(albumName). Please try again"
            present(alertPopUpNotificationViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - ButtonsPopUpNotificationDelegate
extension PreviewWallpaperViewController: ButtonsPopUpNotificationDelegate {
    
    func primaryButtonWasTapped(for buttonsPopUpNotificationViewController: ButtonsPopUpNotificationViewController) {
        buttonsPopUpNotificationViewController.dismiss(animated: true, completion: nil)
    }
    
    func secondaryButtonWasTapped(for buttonsPopUpNotificationViewController: ButtonsPopUpNotificationViewController) {
        buttonsPopUpNotificationViewController.dismiss(animated: true) {
            print("Present Wallpaper Guide")
        }
    }
}
