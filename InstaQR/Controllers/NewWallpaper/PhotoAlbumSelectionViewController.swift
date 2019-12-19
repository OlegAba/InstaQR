//
//  PhotoAlbumViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import PhotosUI
import LPLivePhotoGenerator

protocol PhotoAlbumDelegate {
    func photoAlbum(_ photoAlbumViewController: PhotoAlbumViewController, didSelect album: PhotoAlbum)
}

class PhotoAlbumViewController: UIViewController {
    
    var livePhoto: LPLivePhoto!
    var delegate: PhotoAlbumDelegate!
    
    // MARK: - Private Properties
    
    fileprivate lazy var photoLibraryPermissionHandlerView: PermissionHandlerView = {
        let permissionHandlerVideo = PermissionHandlerView()
        permissionHandlerVideo.permissionType = .photoLibraryUsage
        permissionHandlerVideo.addAccessButtonTarget(self, action: #selector(permissionAccessButtonWasTapped), for: .touchUpInside)
        permissionHandlerVideo.isHidden = true
        permissionHandlerVideo.translatesAutoresizingMaskIntoConstraints = false
        return permissionHandlerVideo
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(NewWallpaperTableViewCell.self, forCellReuseIdentifier: albumTableViewCellID)
        tableView.separatorStyle = .none
        tableView.rowHeight = 100.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    fileprivate let albumTableViewCellID = "AlbumTableViewCellReuseIdentifier"
    
    fileprivate var photoAlbums = [PhotoAlbum]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonWasTapped))
        navigationItem.rightBarButtonItem = cancelBarButtonItem
        setupViews()
        setupRequisiteViews(for: PHPhotoLibrary.authorizationStatus())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        view.addSubview(photoLibraryPermissionHandlerView)
    }
    
    fileprivate func setupRequisiteViews(for authorizationStatus: PHAuthorizationStatus) {
        
        switch authorizationStatus {
            
        case .authorized:
            loadPhotoAlbums()
            
        case .denied, .restricted:
            photoLibraryPermissionHandlerView.buttonType = .settings
            photoLibraryPermissionHandlerView.isHidden = false
            
        case .notDetermined:
            photoLibraryPermissionHandlerView.buttonType = .access
            photoLibraryPermissionHandlerView.isHidden = false
            
        default:
            break
        }
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            photoLibraryPermissionHandlerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoLibraryPermissionHandlerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            photoLibraryPermissionHandlerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            photoLibraryPermissionHandlerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc fileprivate func cancelButtonWasTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func permissionAccessButtonWasTapped() {
        photoLibraryPermissionHandlerView.isHidden = true
        
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            DispatchQueue.main.async {
                
                if status == .authorized {
                    self.loadPhotoAlbums()
                } else {
                    self.setupRequisiteViews(for: .denied)
                }
            }
        }
    }
    
    fileprivate func loadPhotoAlbums() {
        photoAlbums = ImageManager.shared.grabAllPhotosAlbum() + ImageManager.shared.grabUserCreatedAlbums(nonEmpty: false)
        tableView.reloadData()
        navigationItem.title = "Select Album"
    }
}

extension PhotoAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: albumTableViewCellID, for: indexPath) as? NewWallpaperTableViewCell else { return UITableViewCell() }
        
        let photoAlbum = photoAlbums[indexPath.row]
        
        cell.isLast = true
        cell.backgroundColor = .clear
        cell.deviceWallpaperIconView.isHidden = true
        cell.title = photoAlbum.name
        cell.subtitle = String(photoAlbum.assets.count)
        cell.logoImageView.contentMode = .scaleAspectFill
        cell.logoImageView.clipsToBounds = true
        
        let imageSize = CGSize(width: 250.0, height: 250.0)
        
        DispatchQueue.global(qos: .background).async {
            photoAlbum.grabThumbnail(imageSize: imageSize) { (thumbnail: UIImage?) in
                
                DispatchQueue.main.async {
                    cell.logoImage = thumbnail
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoAlbum = photoAlbums[indexPath.row]
        delegate.photoAlbum(self, didSelect: photoAlbum)
    }
}
