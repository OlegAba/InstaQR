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
        case .faq: return .questionMarkIcon
        case .liveWallpaper: return .infoIcon
        case .onBoarding: return .boxIcon
        }
    }
    
    var logoBackgroundColor: UIColor {
        switch self {
        case .faq: return .clear
        case .liveWallpaper: return .clear
        case .onBoarding: return .clear
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
        case .rate: return .starIcon
        case .share: return .shareIcon
        case .licenses: return .letterCIcon
        case .privacyPolicy: return .docIcon
        }
    }
    
    var logoBackgroundColor: UIColor {
        switch self {
        case .rate: return .clear
        case .share: return .clear
        case .licenses: return .clear
        case .privacyPolicy: return .clear
        }
    }
}
