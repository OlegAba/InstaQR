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
        case .faq: return nil
        case .liveWallpaper: return nil
        case .onBoarding: return nil
        }
    }
    
    var logoBackgroundColor: UIColor {
        switch self {
        case .faq: return UIColor(red: 251/255.0, green: 55/255.0, blue: 48/255.0, alpha: 1.0)
        case .liveWallpaper: return UIColor(red: 2/255.0, green: 111/255.0, blue: 247/255.0, alpha: 1.0)
        case .onBoarding: return UIColor(red: 49/255.0, green: 191/255.0, blue: 87/255.0, alpha: 1.0)
        }
    }
}

enum GeneralItem: Int, CaseIterable, SettingsItemType {
    case rate
    case licenses
    case privacyPolicy
    
    var description: String {
        switch self {
        case .rate: return "Rate on the App Store"
        case .licenses: return "Licenses"
        case .privacyPolicy: return "Privacy Policy"
        }
    }
    
    var logoImage: UIImage? {
        switch self {
        case .rate: return nil
        case .licenses: return nil
        case .privacyPolicy: return nil
        }
    }
    
    var logoBackgroundColor: UIColor {
        switch self {
        case .rate: return UIColor(red: 252/255.0, green: 138/255.0, blue: 36/255.0, alpha: 1.0)
        case .licenses: return UIColor(red: 77/255.0, green: 76/255.0, blue: 203/255.0, alpha: 1.0)
        case .privacyPolicy: return UIColor(red: 48/255.0, green: 159/255.0, blue: 210/255.0, alpha: 1.0)
        }
    }
}
