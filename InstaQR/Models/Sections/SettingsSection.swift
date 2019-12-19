//
//  SettingsSection.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

fileprivate protocol SettingsItemType: CustomStringConvertible {
    var logoImage: UIImage? { get }
    var logoBackgroundColor: UIColor { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Help
    case General
    
    var description: String {
        switch self {
        case .Help: return "Help"
        case .General: return "General"
        }
    }
}

enum HelpItem: Int, CaseIterable, SettingsItemType {
    
    case faq
    case liveWallpaper
    case onBoarding
    
    var description: String {
        switch self {
        case .faq: return "F.A.Q"
        case .liveWallpaper: return "Wallpaper Guide"
        case .onBoarding: return "Features"
        }
    }
    
    var logoImage: UIImage? {
        switch self {
        case .faq: return UIImage(systemName: "questionmark.circle")
        case .liveWallpaper: return UIImage(systemName: "info.circle")
        case .onBoarding: return UIImage(systemName: "cube.box")
        }
    }
    
    var logoBackgroundColor: UIColor {
        switch self {
        case .faq: return UIColor(red: 216 / 255.0, green: 109 / 255.0, blue: 78 / 255.0, alpha: 1.0)
        case .liveWallpaper: return UIColor(red: 42 / 255.0, green: 190 / 183.0, blue: 105 / 255.0, alpha: 1.0)
        case .onBoarding: return UIColor(red: 77 / 255.0, green: 186 / 255.0, blue: 230 / 255.0, alpha: 1.0)
        }
    }
}

// TODO: Add credits section
enum GeneralItem: Int, CaseIterable, SettingsItemType {
    case rate
    case share
    case licenses
    case privacyPolicy
    
    var description: String {
        switch self {
        case .rate: return "Rate on the App Store"
        case .share: return "Tell a Friend"
        case .licenses: return "Licenses"
        case .privacyPolicy: return "Privacy Policy"
        }
    }
    
    var logoImage: UIImage? {
        switch self {
        case .rate: return UIImage(systemName: "star.circle")
        case .share: return UIImage(systemName: "square.and.arrow.up")
        case .licenses: return UIImage(systemName: "c.circle")
        case .privacyPolicy: return UIImage(systemName: "doc.plaintext")
        }
    }
    
    var logoBackgroundColor: UIColor {
        switch self {
        case .rate: return UIColor(red: 254 / 255.0, green: 204 / 255.0, blue: 39 / 255.0, alpha: 1.0)
        case .share: return UIColor(red: 0 / 255.0, green: 112 / 183.0, blue: 183 / 255.0, alpha: 1.0)
        case .licenses: return UIColor(red: 189 / 255.0, green: 189 / 255.0, blue: 189 / 255.0, alpha: 1.0)
        case .privacyPolicy: return UIColor(red: 59.0 / 255.0, green: 68.0 / 255.0, blue: 75 / 255.0, alpha: 1.0)
        }
    }
}
