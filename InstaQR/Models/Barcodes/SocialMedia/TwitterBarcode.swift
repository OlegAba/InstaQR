//
//  TwitterBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class TwitterBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .twitter)
        
        userInputs[.twitterHandle] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // help.twitter.com/en/managing-your-account/twitter-username-rules
        
        let title = self.title!
        let sanitizedData = data.trimmingCharacters(in: .whitespaces).lowercased()
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count > 15 {
            return (false, "\(title) handle cannot be longer than 15 character")
        }
        
        if sanitizedData.contains("Twitter") || sanitizedData.contains("Admin") {
            return (false, "\(title) handle cannot contain the words Twitter or Admin")
        }
        
        for char in sanitizedData {
            if char.isLetter || char.isNumber || char == "_" {
                continue
            }
            
            return (false, "\(title) handle can only contain alphanumeric characters (letters A-Z, numbers 0-9) and underscores (symbol _)")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let profileHandle = userInputs[.twitterHandle], !profileHandle.isEmpty else { return nil }
        let data = "Twitter.com/\(profileHandle)"
        
        return data
    }
}
