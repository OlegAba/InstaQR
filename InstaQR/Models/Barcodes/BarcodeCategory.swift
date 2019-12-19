//
//  BarcodeCategory.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class BarcodeCategory: NSObject {
    
    enum BarcodeCategoryType: String {
        case social = "Social Media Profile"
        case payment = "Payment Address"
        case standard = "Standard"
    }
    
    static func titleFor(barcodeCategoryType: BarcodeCategoryType) -> String {
        let barcodeCategoryName = barcodeCategoryType.rawValue
        return barcodeCategoryName
    }
    
    static func barcodeTypesFor(barcodeCategoryType: BarcodeCategoryType) -> [Barcode.BarcodeType] {
        
        switch barcodeCategoryType {
        case .social:
            
            return [Barcode.BarcodeType.twitter, Barcode.BarcodeType.facebook,
                    Barcode.BarcodeType.instagram, Barcode.BarcodeType.snapchat,
                    Barcode.BarcodeType.linkedin, Barcode.BarcodeType.yelp,
                    Barcode.BarcodeType.tumblr, Barcode.BarcodeType.reddit,
                    Barcode.BarcodeType.pinterest, Barcode.BarcodeType.youtube]
            
        case .payment:
            
            return [Barcode.BarcodeType.bitcoin, Barcode.BarcodeType.ethereum,
                    Barcode.BarcodeType.monero, Barcode.BarcodeType.litecoin,
                    Barcode.BarcodeType.bitcoinCash, Barcode.BarcodeType.ripple,
                    Barcode.BarcodeType.paypal, Barcode.BarcodeType.venmo,
                    Barcode.BarcodeType.cash]
            
        case .standard:
            
            return [Barcode.BarcodeType.custom, Barcode.BarcodeType.website,
                    Barcode.BarcodeType.email]
            
        }
    }
}
