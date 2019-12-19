//
//  WallpaperGuideSections.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

struct WallpaperGuideSection {
    let sectionTitle: String
    let sectionSubtitle: String
    let image: UIImage?
}

let wallpaperGuideSections: [WallpaperGuideSection] = [
    
    WallpaperGuideSection(sectionTitle: "Open Settings",
                          sectionSubtitle: "Open settings application located somewhere on your home screen.",
                          image: UIImage(named: "preview")),
    WallpaperGuideSection(sectionTitle: "Tap Wallpaper",
                          sectionSubtitle: "Search for or scroll down to the wallpaper row and tap on it.",
                          image: UIImage(named: "preview")),
    WallpaperGuideSection(sectionTitle: "Tap Choose a New Wallpaper",
                          sectionSubtitle: "Select the album you saved your wallpaper to and tap on the wallpaper",
                          image: UIImage(named: "preview"))
]
