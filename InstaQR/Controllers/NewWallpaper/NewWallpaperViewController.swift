//
//  NewWallpaperViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import LPLivePhotoGenerator

class NewWallpaperViewController: InsetGroupedTableViewController {
    
    // MARK: - Internal Properties
    
    var wallpaperImage: UIImage?
    var wallpaperSource: String?
    var barcode: Barcode?
    var barcodeLink: String?
    
    // MARK: - Private Properties
    
    fileprivate lazy var createPrimaryButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Create", for: .normal)
        button.addTarget(self, action: #selector(createButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        view.addSubview(createPrimaryButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            createPrimaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createPrimaryButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            createPrimaryButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    // MARK: - Setup
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "New Wallpaper"
        
        let deleteTrashIconImage = UIImage(systemName: "trash.circle.fill")
        let deleteBarButtonItem = UIBarButtonItem(image: deleteTrashIconImage, style: .plain, target: self, action: #selector(deleteButtonWasTapped))
        deleteBarButtonItem.tintColor = .systemRed
        navigationItem.rightBarButtonItem = deleteBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let settingsBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonWasTapped))
        navigationItem.leftBarButtonItem = settingsBarButtonItem
    }
    
    fileprivate func setupTableView() {
        subtitle = "Create a new share action live wallpaper to use on your lockscreen."
        tableHeaderViewBottomInset = tableHeaderViewBottomInset * 2.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewWallpaperTableViewCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.rowHeight = 100.0
        tableView.isScrollEnabled = false
    }
    
    // MARK: - Actions
    
    @objc fileprivate func settingsButtonWasTapped() {
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        present(settingsViewController, animated: true, completion: nil)
    }
    
    @objc func deleteButtonWasTapped() {
        let buttonsPopUpNotificationViewController = ButtonsPopUpNotificationViewController()
        buttonsPopUpNotificationViewController.modalPresentationStyle = .overFullScreen
        buttonsPopUpNotificationViewController.messageText = "Are you sure you want to delete the current wallpaper?"
        buttonsPopUpNotificationViewController.delegate = self
        present(buttonsPopUpNotificationViewController, animated: true, completion: nil)
    }
    
    @objc func createButtonWasTapped() {
        if wallpaperImage == nil {
            let row = WallpaperItem.selectWallpaper.rawValue
            let section = NewWallpaperSection.Wallpaper.rawValue
            let indexPath = IndexPath(row: row, section: section)
            (tableView.cellForRow(at: indexPath) as? NewWallpaperTableViewCell)?.animateRequiredBorder()
        }
        
        if barcode == nil {
            let row = ShareActionItem.shareAction.rawValue
            let section = NewWallpaperSection.ShareAction.rawValue
            let indexPath = IndexPath(row: row, section: section)
            (tableView.cellForRow(at: indexPath) as? NewWallpaperTableViewCell)?.animateRequiredBorder()
        }
        
        createLiveWallpaper()
    }
    
    // MARK: - Private Methods
    
    fileprivate func createLiveWallpaper() {
        guard let wallpaperImage = wallpaperImage, let barcode = barcode else { return }
        
        let loadingNotificationViewController = LoadingNotificationViewController()
        loadingNotificationViewController.modalPresentationStyle = .overFullScreen
        loadingNotificationViewController.message = "Creating Live Wallpaper..."
        
        present(loadingNotificationViewController, animated: true) {
            
            let uuid = UUID().uuidString
            let livePhotoGenerator = GenerateLiveWallpaperWithBarcode(fileName: uuid, wallpaperImage: wallpaperImage, barcode: barcode)
            livePhotoGenerator.create { (livePhoto: LPLivePhoto?) in
                
                DispatchQueue.main.async {
                    
                    loadingNotificationViewController.dismiss(animated: true) {
                        
                        if let livePhoto = livePhoto {
                            
                            let previewWallpaperViewController = PreviewWallpaperViewController()
                            previewWallpaperViewController.modalPresentationStyle = .overFullScreen
                            previewWallpaperViewController.livePhoto = livePhoto
                            self.present(previewWallpaperViewController, animated: true)
                            
                            System.shared.firstTimeLaunchingFinished()
                            
                        } else {
                            System.shared.appDelegate().newWallpaperNavigationController?.presentError()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Internal Methods
    
    func set(wallpaperImage: UIImage, sourceTitle: String) {
        self.wallpaperImage = wallpaperImage
        self.wallpaperSource = sourceTitle
        tableView.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func set(barcode: Barcode, shareActionLink: String) {
        self.barcode = barcode
        self.barcodeLink = shareActionLink
        tableView.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

// MARK: - ButtonsPopUpNotificationDelegate
extension NewWallpaperViewController: ButtonsPopUpNotificationDelegate {
    
    // NOTE: - Button confirms deletion of current wallpaper
    func primaryButtonWasTapped(for buttonsPopUpNotificationViewController: ButtonsPopUpNotificationViewController) {
        
        buttonsPopUpNotificationViewController.dismiss(animated: true) {
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.wallpaperImage = nil
            self.wallpaperSource = nil
            self.barcode = nil
            self.barcodeLink = nil
            
            self.animateReloadAllRows()
        }
    }
}

// MARK: - UITableViewDataSource
extension NewWallpaperViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NewWallpaperSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = NewWallpaperSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Wallpaper: return WallpaperItem.allCases.count
        case .ShareAction: return ShareActionItem.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as? NewWallpaperTableViewCell else { return UITableViewCell() }
        
        cell.isLast = rowIsLast(for: indexPath)
        
        guard let section = NewWallpaperSection(rawValue: indexPath.section) else { return cell }
        
        switch section {
        case .Wallpaper:
            
            guard let wallpaperItem = WallpaperItem(rawValue: indexPath.row) else { return cell }
            let wallpaperViewModel = NewWallpaperViewModel(newWallpaperItem: wallpaperItem)
            setup(viewModel: wallpaperViewModel, for: section)
            cell.set(viewModel: wallpaperViewModel)
        case .ShareAction:
            
            guard let shareActionItem = ShareActionItem(rawValue: indexPath.row) else { return cell }
            let shareActionViewModel = NewWallpaperViewModel(newWallpaperItem: shareActionItem)
            setup(viewModel: shareActionViewModel, for: section)
            cell.set(viewModel: shareActionViewModel)
        }
        
        return cell
    }
    
    fileprivate func setup(viewModel: NewWallpaperViewModel, for newWallpaperSection: NewWallpaperSection) {
        viewModel.wallpaperImage = wallpaperImage
        
        switch newWallpaperSection {
        case .Wallpaper:
            
            viewModel.subtitle = wallpaperSource
            viewModel.isComplete = (wallpaperImage != nil)
        case .ShareAction:
            
            viewModel.barcodeImage = barcode?.icon
            viewModel.subtitle = barcodeLink
            viewModel.isComplete = (barcode != nil)
        }
    }
    
}

// MARK: - UITableViewDelegate
extension NewWallpaperViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        deselectTableViewRow()
        
        guard let newWallpaperNavigationController = System.shared.appDelegate().newWallpaperNavigationController else { return }
        
        guard let section = NewWallpaperSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Wallpaper:
            
            let selectWallpaperViewController = SelectWallpaperViewController()
            selectWallpaperViewController.delegate = newWallpaperNavigationController
            newWallpaperNavigationController.pushViewController(selectWallpaperViewController, animated: true)
        case .ShareAction:
            
            let createShareActionViewController = CreateShareActionViewController()
            createShareActionViewController.delegate = newWallpaperNavigationController
            newWallpaperNavigationController.pushViewController(createShareActionViewController, animated: true)
        }
    }
}
