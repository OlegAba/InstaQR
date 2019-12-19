//
//  NewWallpaperViewModel.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class NewWallpaperViewModel {
    
    var wallpaperImage: UIImage? {
        didSet {
            let widthAspectRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
            let height: CGFloat = 200
            let width = height * widthAspectRatio
            let wallpaperImageThumbnail = wallpaperImage?.resized(size: CGSize(width: width, height: height))
            
            wallpaperImage = wallpaperImageThumbnail
        }
    }
    
    var barcodeImage: UIImage? {
        didSet {
            barcodeImage = barcodeImage ?? newWallpaperItem.overlayImage
        }
    }
    
    var isComplete = false {
        didSet {
            iconImage = isComplete ? .checkmarkIcon : .chevronRightIcon
            iconColor = isComplete ? UIColor.systemGreen : UIColor.placeholderText
            title = isComplete ? newWallpaperItem.completedDescription : newWallpaperItem.description
        }
    }
    
    var title: String
    var subtitle: String?
    var iconImage: UIImage = .chevronRightIcon
    var iconColor: UIColor = UIColor.placeholderText
    
    fileprivate let newWallpaperItem: NewWallpaperItemType
    
    init(newWallpaperItem: NewWallpaperItemType) {
        self.newWallpaperItem = newWallpaperItem
        self.title = newWallpaperItem.description
        self.barcodeImage = newWallpaperItem.overlayImage
    }
    
}
