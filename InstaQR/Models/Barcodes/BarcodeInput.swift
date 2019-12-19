//
//  BarcodeInput.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class BarcodeInput: NSObject {

    let key: KeyType!
    let instructions: String!
    let placeholder: String!
    let barcodeScanEnabled: Bool!
    
    enum KeyType {
        // Social media
        case twitterHandle
        case facebookHandle
        case instagramHandle
        case snapchatHandle
        case linkedinHandle
        case yelpUserID
        case tumblrName
        case redditHandle
        case pinterestHandle
        case youtubeChannelName
        
        // Payment Address
        case bitcoinAddress
        case ethereumAddress
        case moneroAddress
        case litecoinAddress
        case bitcoinCashAddress
        case rippleAddress
        case paypalMerchantID
        case venmoUsername
        case cashTag
        
        // Standard / Generics
        case genericUrl
        case genericEmail
        case genericNote
    }

    init(key: KeyType, instructions: String, placeholder: String, bacodeScanEnabled: Bool) {
        self.key = key
        self.instructions = instructions
        self.placeholder = placeholder
        self.barcodeScanEnabled = bacodeScanEnabled
    }
    
    // TODO: FINALIZE INSTRUCTIONS, PLACEHOLDER, AND BARCODESCANENABLED
    static let KeyTranslationDict: [KeyType: (instructions: String, placeholder: String, barcodeScanEnabled: Bool)] = [
        
        // Social Media
        KeyType.twitterHandle : (instructions: "Enter Your Twitter Handle", placeholder: "xo_leg", barcodeScanEnabled: false),
        KeyType.facebookHandle : (instructions: "Enter Your Facebook Handle", placeholder: "xo_leg", barcodeScanEnabled: false),
        KeyType.instagramHandle : (instructions: "Enter Your Instagram Handle", placeholder: "xo_leg", barcodeScanEnabled: false),
        KeyType.snapchatHandle : (instructions: "Enter Your Snapchat Handle", placeholder: "xo_leg", barcodeScanEnabled: false),
        KeyType.linkedinHandle : (instructions: "Enter Your LinkedIn Handle", placeholder: "xo_leg", barcodeScanEnabled: false),
        KeyType.yelpUserID : (instructions: "Enter Your Yelp User Identifier", placeholder: "MR1HQbbPqyR0ymBi1rNbdg", barcodeScanEnabled: false),
        KeyType.tumblrName : (instructions: "Enter Your Tumblr Name", placeholder: "Dedalvs", barcodeScanEnabled: false),
        KeyType.redditHandle : (instructions: "Enter Your Reddit Handle", placeholder: "xo_leg", barcodeScanEnabled: false),
        KeyType.pinterestHandle : (instructions: "Enter Your Pinterest Handle", placeholder: "xo_leg", barcodeScanEnabled: false),
        KeyType.youtubeChannelName : (instructions: "Enter Your Youtube Channel Name", placeholder: "PowerfulJRE", barcodeScanEnabled: false),
        
        // Payment Address
        KeyType.bitcoinAddress : (instructions: "Enter Your Bitcoin (BTC) Address", placeholder: "3P3QsMVK89JBNqZQv5zMAKG8FK3kJM4rjt", barcodeScanEnabled: true),
        KeyType.ethereumAddress : (instructions: "Enter Your Ethereum (ETH) Address", placeholder: "0x2E272DE22DEd37A971794E0eC3b32Ac3907a7c05", barcodeScanEnabled: true),
        KeyType.moneroAddress : (instructions: "Enter Your Monero (XMR) Address", placeholder: "45KPbNGAZ9pTcZi9AJwgufSYBuhVHoyATdhU9sjGtGqn1UkW99Dcj3gLGRH5t1KsRSN157SvbWZGZJNRd8VKV9Cz3ZbPCxL", barcodeScanEnabled: true),
        KeyType.litecoinAddress : (instructions: "Enter Your Litecoin (LTC) Address", placeholder: "3CDJNfdWX8m2NwuGUV3nhXHXEeLygMXoAj", barcodeScanEnabled: true),
        KeyType.bitcoinCashAddress : (instructions: "Enter Your Bitcoin Cash (BCH) Address", placeholder: "pp8skudq3x5hzw8ew7vzsw8tn4k8wxsqsv0lt0mf3g", barcodeScanEnabled: true),
        KeyType.rippleAddress : (instructions: "Enter Your Ripple (XRP) Address", placeholder: "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn", barcodeScanEnabled: true),
        KeyType.paypalMerchantID : (instructions: "Enter Your Paypal Merchant ID", placeholder: "ID4MED2H3WDH3U1", barcodeScanEnabled: false),
        KeyType.venmoUsername : (instructions: "Enter Your Venmo Username", placeholder: "@xo_leg", barcodeScanEnabled: false),
        KeyType.cashTag : (instructions: "Enter Your CashTag", placeholder: "$xo_leg", barcodeScanEnabled: false),
        
        // Generics
        KeyType.genericUrl : (instructions: "Enter the URL to Your Website", placeholder: "SuperQR.com", barcodeScanEnabled: false),
        KeyType.genericEmail : (instructions: "Enter Your Email Address", placeholder: "SuperQR@gmail.com", barcodeScanEnabled: false),
        KeyType.genericNote : (instructions: "Enter Custom Link or Message", placeholder: "Hello...", barcodeScanEnabled: false),
    ]
    
    static func inputsTranslationFor(barcode: Barcode) -> [BarcodeInput]? {

        var barcodeInputsTranslations: [BarcodeInput] = []
        
        for userInputKey in barcode.userInputs.keys {
         
            guard let instructions = KeyTranslationDict[userInputKey]?.instructions,
                  let placeholder = KeyTranslationDict[userInputKey]?.placeholder,
                  let barcodeScanEnabled = KeyTranslationDict[userInputKey]?.barcodeScanEnabled
                  else { return nil }
            let barcodeInput = BarcodeInput(key: userInputKey, instructions: instructions, placeholder: placeholder, bacodeScanEnabled: barcodeScanEnabled)
            
            barcodeInputsTranslations.append(barcodeInput)
        }

        return barcodeInputsTranslations
    }
}

