//
//  PageSection.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

struct PageSection {
    let title: String
    let subtitle: String
    let gifFileName: String
    let placeholderImageFileName: String
}

let onBoardingPageSections: [PageSection] = [

    PageSection(title: "Live Wallpaper",
                subtitle: """
                \(System.shared.appName) generates a live wallpaper by combining an image of your choice with a
                scannable QR code. The QR code stores your share action and stays hidden until the live wallpaper
                is activated by pressing into the screen.
                """,
                gifFileName: "tutorial.gif",
                placeholderImageFileName: "preview"),
    PageSection(title: "Scannable",
                subtitle: "Works with any iPhone camera and any QR reader",
                gifFileName: "tutorial.gif",
                placeholderImageFileName: "preview"),
    PageSection(title: "PLACEHOLDER",
                subtitle: "TEMP",
                gifFileName: "tutorial.gif",
                placeholderImageFileName: "preview")
]

let wallpaperGuidePageSections: [PageSection] = [
    
    PageSection(title: "1.",
                subtitle: "Open settings application located somewhere on your home screen.",
                gifFileName: "tutorial.gif",
                placeholderImageFileName: "preview"),
    PageSection(title: "Tap Wallpaper",
                subtitle: "Search for or scroll down to the wallpaper row and tap on it.",
                gifFileName: "tutorial.gif",
                placeholderImageFileName: "preview"),
    PageSection(title: "Tap Choose a New Wallpaper",
                subtitle: "Select the album you saved your wallpaper to and tap on the wallpaper",
                gifFileName: "tutorial.gif",
                placeholderImageFileName: "preview")
]
