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
    
    static let KeyTranslationDict: [KeyType: (instructions: String, placeholder: String, barcodeScanEnabled: Bool)] = [
        
        // Social Media
        KeyType.twitterHandle : (instructions: "Share Twitter Profile", placeholder: "Enter your Twitter handle", barcodeScanEnabled: false),
        KeyType.facebookHandle : (instructions: "Share Facebook Profile", placeholder: "Enter your Facebook handle", barcodeScanEnabled: false),
        KeyType.instagramHandle : (instructions: "Share Instagram Profile", placeholder: "Enter your Instagram handle", barcodeScanEnabled: false),
        KeyType.snapchatHandle : (instructions: "Share Snapchat Profile", placeholder: "Enter your Snapchat handle", barcodeScanEnabled: false),
        KeyType.linkedinHandle : (instructions: "Share LinkedIn Profile", placeholder: "Enter your LinkedIn handle", barcodeScanEnabled: false),
        KeyType.tumblrName : (instructions: "Share Tumblr Profile", placeholder: "Enter your Tumblr handle", barcodeScanEnabled: false),
        KeyType.redditHandle : (instructions: "Share Reddit Profile", placeholder: "Enter your Reddit handle", barcodeScanEnabled: false),
        KeyType.pinterestHandle : (instructions: "Share Pinterest Profile", placeholder: "Enter your Pinterest handle", barcodeScanEnabled: false),
        KeyType.youtubeChannelName : (instructions: "Share Youtube Channel", placeholder: "Enter your Youtube channel name", barcodeScanEnabled: false),
        
        // Payment Address
        
        KeyType.bitcoinAddress : (instructions: "Share Bitcoin (BTC) Address", placeholder: "3P3QsMVK89JBNqZQv5zMAKG8FK3kJM4rjt", barcodeScanEnabled: true),
        KeyType.ethereumAddress : (instructions: "Share Ethereum (ETH) Address", placeholder: "0x2E272DE22DEd37A971794E0eC3b32Ac3907a7c05", barcodeScanEnabled: true),
        KeyType.moneroAddress : (instructions: "Share Monero (XMR) Address", placeholder: "45KPbNGAZ9pTcZi9AJwgufSYBuhVHoyATdhU9sjGtGqn1UkW99Dcj3gLGRH5t1KsRSN157SvbWZGZJNRd8VKV9Cz3ZbPCxL", barcodeScanEnabled: true),
        KeyType.litecoinAddress : (instructions: "Share Litecoin (LTC) Address", placeholder: "3CDJNfdWX8m2NwuGUV3nhXHXEeLygMXoAj", barcodeScanEnabled: true),
        KeyType.bitcoinCashAddress : (instructions: "Share Bitcoin Cash (BCH) Address", placeholder: "pp8skudq3x5hzw8ew7vzsw8tn4k8wxsqsv0lt0mf3g", barcodeScanEnabled: true),
        KeyType.rippleAddress : (instructions: "Share Ripple (XRP) Address", placeholder: "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn", barcodeScanEnabled: true),
        KeyType.venmoUsername : (instructions: "Share Venmo Username", placeholder: "Enter your Venmo username", barcodeScanEnabled: false),
        KeyType.cashTag : (instructions: "Share CashTag", placeholder: "Enter Your CashTag", barcodeScanEnabled: false),
        
        // Generics
        KeyType.genericUrl : (instructions: "Share Website", placeholder: "\(System.shared.appName).com", barcodeScanEnabled: false),
        KeyType.genericEmail : (instructions: "Share Email Address", placeholder: "\(System.shared.appName).com", barcodeScanEnabled: false),
        KeyType.genericNote : (instructions: "Share Custom Link or Message", placeholder: "Hello...", barcodeScanEnabled: false),
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

