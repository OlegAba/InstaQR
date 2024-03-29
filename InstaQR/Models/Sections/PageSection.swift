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
    let gifFileName: String?
    let placeholderImageFileName: String
}

let onBoardingPageSections: [PageSection] = [

    PageSection(title: "Live Wallpaper",
                subtitle: "Generate a Live Photo by combining an image and a share action QR code.",
                gifFileName: "live-wallpaper-gif.gif",
                placeholderImageFileName: "live-wallpaper-placeholder"),
    PageSection(title: "Scannable",
                subtitle: "Share anything, all without leaving your lock screen.",
                gifFileName: "scannable-gif.gif",
                placeholderImageFileName: "scannable-placeholder"),
    PageSection(title: "Share Action",
                subtitle: "Use one of our share action templates or create your own.",
                gifFileName: nil,
                placeholderImageFileName: "share-action-placeholder")
]

let wallpaperGuidePageSections: [PageSection] = [
    
    PageSection(title: "1. Open Settings",
                subtitle: "Go to Settings, tap Wallpaper, then tap Choose a New Wallpaper",
                gifFileName: nil,
                placeholderImageFileName: "open-settings"),
    PageSection(title: "2. Find the Live Wallpaper",
                subtitle: "Tap on the album where you saved your live wallpaper, then tap on the image.",
                gifFileName: nil,
                placeholderImageFileName: "find-live-wallpaper"),
    PageSection(title: "3. Move the wallpaper",
                subtitle: "Drag and/or pinch to zoom in and out, so the wallpaper fits the screen.",
                gifFileName: nil,
                placeholderImageFileName: "move-the-wallpaper"),
    PageSection(title: "4. Toggle Live Photo",
                subtitle: "The Live Photo button is located at the bottom of the screen (second from the left).",
                gifFileName: nil,
                placeholderImageFileName: "toggle-live-photo"),
    PageSection(title: "5. Set the wallpaper",
                subtitle: "Tap Set, then set the wallpaper as your Lock screen, or both.",
                gifFileName: nil,
                placeholderImageFileName: "set-wallpaper")
]
