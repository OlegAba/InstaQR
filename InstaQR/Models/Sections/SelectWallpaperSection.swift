//
//  SelectWallpaperSection.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

fileprivate protocol SelectWallpaperItemType: CustomStringConvertible {
    var logoImage: UIImage? { get }
    var logoBackgroundColor: UIColor { get }
    var iconImage: UIImage { get }
}

enum SelectWallpaperSection: Int, CaseIterable, CustomStringConvertible {
    case Source
    
    var description: String {
        switch self {
        case .Source: return "Source"
        }
    }
}

enum SourceItem: Int, CaseIterable, SelectWallpaperItemType {
    case photoLibrary
    case unsplashGallery
    
    var description: String {
        switch self {
        case .photoLibrary: return "Photo Library"
        case .unsplashGallery: return "Unsplash Gallery"
        }
    }
    
    var logoImage: UIImage? {
        switch self {
        case .photoLibrary: return #imageLiteral(resourceName: "photoLibrary_icon")
        case .unsplashGallery: return #imageLiteral(resourceName: "unsplash_icon")
        }
    }
    
    var logoBackgroundColor: UIColor { return UIColor.white }
    
    var iconImage: UIImage { return .chevronUpIcon }
}
