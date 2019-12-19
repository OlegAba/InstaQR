//
//  SelectWallpaperViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

protocol SelectWallpaperDelegate {
    func selectWallpaper(_ selectWallpaperViewController: SelectWallpaperViewController, didSelectWallpaper wallpaper: UIImage, from source: String)
}

class SelectWallpaperViewController: TableViewController {
    
    // MARK: - Internal Properties
    
    var delegate: SelectWallpaperDelegate!
    
    override var tableHeaderViewBottomInset: CGFloat {
        get { return 32.0 }
    }
    
    // MARK: - Private Properties
    
    fileprivate var unsplashAccessKey: String!
    fileprivate var unsplashSecretKey: String!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Wallpaper"
        setupTableView()
        setupUnsplashKeys()
    }
    
    // MARK: - Setup
    
    fileprivate func setupTableView() {
        subtitle = "Select your favorite wallpaper and crop it to your screen size."
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.rowHeight = 70.0
        tableView.isScrollEnabled = false
    }
    
    fileprivate func setupUnsplashKeys() {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let keysDict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            unsplashAccessKey = (keysDict["unsplashAccessKey"] as? String) ?? ""
            unsplashSecretKey = (keysDict["unsplashSecretKey"] as? String) ?? ""
        }
    }
    
    // MARK: - Private Methods
    
    fileprivate func presentError(with message: String) {
        System.shared.appDelegate().newWallpaperNavigationController?.presentError(with: message)
    }
    
    fileprivate func presentPhotoLibraryImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func presentUnsplashPhotoPicker() {
        // TODO: Fork pod file UnplashPhotoPickerController move cancel button is on rightBarButtonItem
        let config = UnsplashPhotoPickerConfiguration(accessKey: unsplashAccessKey, secretKey: unsplashSecretKey, allowsMultipleSelection: false)
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: config)
        unsplashPhotoPicker.photoPickerDelegate = self
        present(unsplashPhotoPicker, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SelectWallpaperViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SelectWallpaperSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SelectWallpaperSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Source: return SourceItem.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as? BaseTableViewCell else { return UITableViewCell() }
        
        cell.isLast = rowIsLast(for: indexPath)
        
        guard let section = SelectWallpaperSection(rawValue: indexPath.section) else { return cell }
        
        switch section {
        case .Source:
            let sourceItem = SourceItem(rawValue: indexPath.row)
            cell.logoImage = sourceItem?.logoImage
            cell.logoImageBackgroundColor = sourceItem?.logoBackgroundColor
            cell.title = sourceItem?.description
            cell.iconImage = sourceItem?.iconImage
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectTableViewRow()
        
        guard let section = SelectWallpaperSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Source:
            let sourceItem = SourceItem(rawValue: indexPath.row)
            
            switch sourceItem {
            case .photoLibrary:
                presentPhotoLibraryImagePickerController()
            case .unsplashGallery:
                presentUnsplashPhotoPicker()
            case .none: break
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SelectWallpaperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true) {
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                self.presentError(with: "There was an error downloading this photo from your Photo Library. Please try again.")
                return
            }
            
            self.delegate.selectWallpaper(self, didSelectWallpaper: image, from: SourceItem.photoLibrary.description)
        }
    }
}

// MARK: - UnsplashPhotoPickerDelegate
extension SelectWallpaperViewController: UnsplashPhotoPickerDelegate {
    
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        
        photoPicker.dismiss(animated: true) {
            
            let loadingNotificationViewController = LoadingNotificationViewController()
            loadingNotificationViewController.modalPresentationStyle = .overFullScreen
            loadingNotificationViewController.message = "Downloading Image..."
            
            self.present(loadingNotificationViewController, animated: true) {
                
                let errorMessage = "There was an error downloading this image from Unsplash. Please try again."
                guard let unsplashPhoto = photos.first else {
                    
                    loadingNotificationViewController.dismiss(animated: true) {
                        self.presentError(with: errorMessage)
                    }
                    
                    return
                }
                
                let unsplashEndpointRequest = UnsplashEndpointRequest(unsplashPhoto: unsplashPhoto)
                unsplashEndpointRequest.start { (image: UIImage?) in
                    
                    DispatchQueue.main.async {
                        
                        loadingNotificationViewController.dismiss(animated: true) {
                            
                            guard let image = image else { self.presentError(with: errorMessage); return }
                            
                            self.delegate.selectWallpaper(self, didSelectWallpaper: image, from: SourceItem.unsplashGallery.description)
                        }
                    }
                }
            }
        }
    }
    
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        dismiss(animated: true, completion: nil)
    }
}
