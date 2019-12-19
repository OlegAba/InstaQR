//
//  Barcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import EFQRCode

class Barcode: NSObject {
    
    let barcodeType: BarcodeType!
    let title: String!
    let icon: UIImage!
    let backgroundImage: UIImage!
    var primaryColor: UIColor!
    
    var userInputs = [BarcodeInput.KeyType: String]()
    
    enum BarcodeType: String {
        // Social Media
        case twitter = "Twitter"
        case facebook = "Facebook"
        case instagram = "Instagram"
        case snapchat = "Snapchat"
        case linkedin = "LinkedIn"
        case yelp = "Yelp"
        case tumblr = "Tumblr"
        case reddit = "Reddit"
        case pinterest = "Pinterest"
        case youtube = "Youtube"
        
        // Payment Address
        case bitcoin = "Bitcoin"
        case ethereum = "Ethereum"
        case monero = "Monero"
        case litecoin = "Litecoin"
        case bitcoinCash = "Bitcoin Cash"
        case ripple = "Ripple"
        case paypal = "Paypal"
        case venmo = "Venmo"
        case cash = "Cash"
        
        // Standard
        case custom = "Custom"
        case website = "Website"
        case email = "Email"
    }
    
    init(barcodeType: BarcodeType) {
        self.barcodeType = barcodeType
        title = Barcode.titleFor(barcodeType: barcodeType)
        icon = Barcode.iconImageFor(barcodeType: barcodeType)
        primaryColor = Barcode.primaryColorFor(barcodeType: barcodeType)
        backgroundImage = Barcode.backgroundImageFor(barcodeType: barcodeType)
    }
    
    static func backgroundImageFor(barcodeType: BarcodeType) -> UIImage? {
        let barcodeTypeName = barcodeType.rawValue
        let logoImageName =  barcodeTypeName.lowercased().replacingOccurrences(of: " ", with: "") + "_background"
        
        return UIImage(named: logoImageName)
    }
    
    static func titleFor(barcodeType: BarcodeType) -> String {
        let barcodeTypeName = barcodeType.rawValue
        
        return barcodeTypeName
    }
    
    static func iconImageFor(barcodeType: BarcodeType) -> UIImage? {
        let barcodeTypeName = barcodeType.rawValue
        let logoImageName =  barcodeTypeName.lowercased().replacingOccurrences(of: " ", with: "") + "_icon"
        
        return UIImage(named: logoImageName)
    }
    
    static func primaryColorFor(barcodeType: BarcodeType) -> UIColor? {
        return UIColor.barcodeTypePrimaryColorDict[barcodeType]
    }
    
    func generateQRImageWith(data: String, size: CGSize) -> UIImage? {
        if let QRImage = EFQRCode.generate(content: data,
                                           size: EFIntSize(width: Int(size.width), height: Int(size.height)),
                                           backgroundColor: UIColor.white.cgColor,
                                           foregroundColor: UIColor.black.cgColor) {
            return UIImage(cgImage: QRImage)
        } else {
            print("ERROR generating QR image")
            return nil
        }
    }
    
    func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        if data.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        return (true, nil)
    }
    
    func generateDataFromInputs() -> String? {
        return nil
    }
    
    internal func truncateCryptoIdentifier(cryptoBarcodeTitle: String, data: String) -> String {
        let identifier = cryptoBarcodeTitle.lowercased() + ":"
        guard let index = data.indexDistance(of: identifier) else { return data }
        
        if index != 0 {
            return data
        }
        
        let truncatedData = data.replacingFirstOccurrenceOfString(target: identifier, withString: "")
        
        return truncatedData
    }
    
    static func get(for barcodeType: Barcode.BarcodeType) -> Barcode {
        
        switch barcodeType {
        case .twitter:
            return TwitterBarcode()
        case .facebook:
            return FacebookBarcode()
        case .instagram:
            return InstagramBarcode()
        case .snapchat:
            return SnapchatBarcode()
        case .linkedin:
            return LinkedinBarcode()
        case .yelp:
            return YelpBarcode()
        case .tumblr:
            return TumblrBarcode()
        case .reddit:
            return RedditBarcode()
        case .pinterest:
            return PinterestBarcode()
        case .youtube:
            return YoutubeBarcode()
        case .bitcoin:
            return BitcoinBarcode()
        case .ethereum:
            return EthereumBarcode()
        case .monero:
            return MoneroBarcode()
        case .litecoin:
            return LitecoinBarcode()
        case .bitcoinCash:
            return BitcoinCashBarcode()
        case .ripple:
            return RippleBarcode()
        case .paypal:
            return PaypalBarcode()
        case .venmo:
            return VenmoBarcode()
        case .cash:
            return CashBarcode()
        case .website:
            return WebsiteBarcode()
        case .custom:
            return CustomBarcode()
        case .email:
            return EmailBarcode()
        }
    }
}
