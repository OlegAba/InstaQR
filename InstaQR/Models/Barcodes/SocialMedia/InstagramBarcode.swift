//
//  InstagramBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class InstagramBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .instagram)
        
        userInputs[.instagramHandle] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        // stackoverflow.com/questions/15470180/character-limit-on-instagram-usernames
        
        let title = self.title!
        let sanitizedData = data.trimmingCharacters(in: .whitespaces).lowercased()
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count > 30 {
            return (false, "\(title) handle cannot be longer than 30 character")
        }
        
        for char in sanitizedData {
            if char.isLetter || char.isNumber || char == "." || char == "_" {
                continue
            }
            
            return (false, "\(title) handle can only contain alphanumeric characters (letters A-Z, numbers 0-9), underscores (symbol _), and periods (symbol .)")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let profileHandle = userInputs[.instagramHandle], !profileHandle.isEmpty else { return nil }
        let data = "Instagram.com/\(profileHandle)"
        
        return data
    }
}
