//
//  NewWallpaperSection.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

protocol NewWallpaperItemType: CustomStringConvertible {
    var completedDescription: String { get }
    var overlayImage: UIImage? { get }
}

enum NewWallpaperSection: Int, CaseIterable {
    case Wallpaper
    case ShareAction
}

enum WallpaperItem: Int, CaseIterable, NewWallpaperItemType {
    case selectWallpaper
    
    // TODO:- Change to Select Wallpaper / Wallpaper
    
    var description: String { return "Select Wallpaper" }
    
    var completedDescription: String { return "Wallpaper" }
    
    var overlayImage: UIImage? { return nil }
}

enum ShareActionItem: Int, CaseIterable, NewWallpaperItemType {
    case shareAction
    
    var description: String { return "Create Share Action" }
    
    var completedDescription: String { return "Share Action" }
    
    var overlayImage: UIImage? { return UIImage(named: "custom_icon") }
}
