//
//  NewWallpaperNavigationController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class NewWallpaperNavigationController: UINavigationController {
    
    // MARK: - Internal Properties
    var newWallpaperViewController: NewWallpaperViewController!
    var wallpaperSource: String!
    
    // MARK: - Lifetime
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        newWallpaperViewController = NewWallpaperViewController()
        super.init(rootViewController: newWallpaperViewController)
        newWallpaperViewController.delegate = self
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Internal Methods
    
    func presentError(with message: String = "There was an unexpected error. Please try again.") {
        let alertPopUpNotificationViewController = AlertPopUpNotificationViewController()
        alertPopUpNotificationViewController.modalPresentationStyle = .overFullScreen
        alertPopUpNotificationViewController.alertType = .error
        alertPopUpNotificationViewController.messageText = message
        present(alertPopUpNotificationViewController, animated: true, completion: nil)
    }
}

// MARK: - NewWallpaperDelegate
extension NewWallpaperNavigationController: NewWallpaperDelegate {
    func newWallpaper(_ newWallpaperViewController: NewWallpaperViewController, didSelectSection section: NewWallpaperSection) {
        
        switch section {
        case .Wallpaper:
            let selectWallpaperViewController = SelectWallpaperViewController()
            selectWallpaperViewController.delegate = self
            pushViewController(selectWallpaperViewController, animated: true)
        case .ShareAction:
            let createShareActionViewController = CreateShareActionViewController()
            createShareActionViewController.delegate = self
            pushViewController(createShareActionViewController, animated: true)
        }
    }
}

// MARK: - SelectWallpaperDelegate
extension NewWallpaperNavigationController: SelectWallpaperDelegate {
    
    func selectWallpaper(_ selectWallpaperViewController: SelectWallpaperViewController, didSelectWallpaper wallpaper: UIImage, from source: String) {
        self.wallpaperSource = source
        let cropWallpaperViewController = CropWallpaperViewController()
        cropWallpaperViewController.imageToCrop = wallpaper
        cropWallpaperViewController.delegate = self
        pushViewController(cropWallpaperViewController, animated: true)
    }
}

// MARK: - CropWallpaperDelegate
extension NewWallpaperNavigationController: CropWallpaperDelegate {
    
    func cropWallpaper(_ cropWallpaperViewController: CropWallpaperViewController, didCropToImage image: UIImage) {
        newWallpaperViewController.set(wallpaperImage: image, sourceTitle: wallpaperSource)
        popToRootViewController(animated: true)
    }
}

// MARK: - CreateShareActionDelegate
extension NewWallpaperNavigationController: CreateShareActionDelegate {
    
    func createShareAction(_ createShareActionViewController: CreateShareActionViewController, didSelectBarcodeType barcodeType: Barcode.BarcodeType, withPrefilledInput prefilledInput: String?) {
        
        let barcode = Barcode.get(for: barcodeType)
        guard let barcodeInput = BarcodeInput.inputsTranslationFor(barcode: barcode)?.first else {
            presentError()
            return
        }
        
        barcode.userInputs[barcodeInput.key] = prefilledInput ?? ""
        
        let userInputViewController = UserInputViewController()
        userInputViewController.barcode = barcode
        userInputViewController.barcodeInput = barcodeInput
        userInputViewController.delegate = self
        
        pushViewController(userInputViewController, animated: true)
    }
}

// MARK: - UserInputDelegate
extension NewWallpaperNavigationController: UserInputDelegate {
     
    func userInput(_ userInputViewController: UserInputViewController, didCreateBarcode barcode: Barcode, withBarcodeInput barcodeInput: BarcodeInput) {
        
        guard let link = barcode.generateDataFromInputs() else {
            presentError()
            return
        }
        
        newWallpaperViewController.set(barcode: barcode, shareActionLink: link)
        popToRootViewController(animated: true)
    }
}

