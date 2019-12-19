//
//  UIColor+.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

extension UIColor {
    
    // TableViewCell Background Color
    static var tableViewCellBackgroundColor: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
                UIColor(red: 44 / 255.0, green: 44 / 255.0, blue: 46 / 255.0, alpha: 1.0) :
                UIColor(red: 242 / 255.0, green: 242 / 255.0, blue: 247 / 255.0, alpha: 1.0)
        }
    }
    
    // Barcode Primary Colors
    static let barcodeTypePrimaryColorDict: [Barcode.BarcodeType: UIColor] = [
        // Social Media
        .twitter : UIColor(red: 35 / 255.0, green: 160 / 255.0, blue: 221 / 255.0, alpha: 1.0),
        .facebook : UIColor(red: 56 / 255.0, green: 89 / 255.0, blue: 205 / 255.0, alpha: 1.0),
        .instagram : UIColor(red: 203 / 255.0, green: 0 / 255.0, blue: 120 / 255.0, alpha: 1.0),
        .snapchat : UIColor(red: 255 / 255.0, green: 211 / 255.0, blue: 29 / 255.0, alpha: 1.0),
        .linkedin : UIColor(red: 0 / 255.0, green: 105 / 255.0, blue: 170 / 255.0, alpha: 1.0),
        .yelp : UIColor(red: 199 / 255.0, green: 30 / 255.0, blue: 31 / 255.0, alpha: 1.0),
        .tumblr : UIColor(red: 43 / 255.0, green: 59 / 255.0, blue: 78 / 255.0, alpha: 1.0),
        .reddit : UIColor(red: 248 / 255.0, green: 53 / 255.0, blue: 23 / 255.0, alpha: 1.0),
        .pinterest : UIColor(red: 220 / 255.0, green: 0 / 255.0, blue: 24 / 255.0, alpha: 1.0),
        .youtube : UIColor(red: 247 / 255.0, green: 0 / 255.0, blue: 1 / 255.0, alpha: 1.0),
        
        // Payment Address
        .bitcoin : UIColor(red: 246 / 255.0, green: 136 / 255.0, blue: 25 / 255.0, alpha: 1.0),
        .ethereum : UIColor(red: 116 / 255.0, green: 117 / 255.0, blue: 118 / 255.0, alpha: 1.0),
        .monero : UIColor(red: 233 / 255.0, green: 90 / 255.0, blue: 30 / 255.0, alpha: 1.0),
        .litecoin : UIColor(red: 177 / 255.0, green: 177 / 255.0, blue: 177 / 255.0, alpha: 1.0),
        .bitcoinCash : UIColor(red: 65 / 255.0, green: 190 / 255.0, blue: 60 / 255.0, alpha: 1.0),
        .ripple: UIColor(red: 18 / 255.0, green: 115 / 255.0, blue: 168 / 255.0, alpha: 1.0),
        
        .paypal : UIColor(red: 33 / 255.0, green: 52 / 255.0, blue: 117 / 255.0, alpha: 1.0),
        .venmo : UIColor(red: 43 / 255.0, green: 135 / 255.0, blue: 192 / 255.0, alpha: 1.0),
        .cash : UIColor(red: 4 / 255.0, green: 208 / 255.0, blue: 44 / 255.0, alpha: 1.0),
        
        // Standard
        .custom : UIColor(red: 22 / 255.0, green: 205 / 255.0, blue: 143 / 255.0, alpha: 1.0),
        .website : UIColor(red: 17 / 255.0, green: 167 / 255.0, blue: 238 / 255.0, alpha: 1.0),
        .email : UIColor(red: 17 / 255.0, green: 167 / 255.0, blue: 238 / 255.0, alpha: 1.0)
    ]
    
    static func getAllBarcodeTypePrimaryColors() -> [UIColor] {
        return Array(barcodeTypePrimaryColorDict.values)
    }
}
