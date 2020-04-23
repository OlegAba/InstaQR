//
//  SnapchatBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class SnapchatBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .snapchat)
        
        userInputs[.snapchatHandle] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // stackoverflow.com/questions/39819830/what-are-the-allowed-character-in-snapchat-username
        
        let title = self.title ?? ""
        let sanitizedData = data.trimmingCharacters(in: .whitespaces).lowercased()
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 3 {
            return (false, "\(title) handle must be at least 3 characters long")
        }
        
        if sanitizedData.count > 15 {
            return (false, "\(title) hande cannot be longer than 15 characters")
        }
        
        for (index, char) in sanitizedData.enumerated() {
            
            if index == 0 && !char.isLetter {
                return (false, "\(title) handle must begin with a letter")
            }
            
            if index == sanitizedData.count - 1 && (char == "-" || char == "_" || char == ".") {
                return (false, "\(title) handle cannot end with a hyphen (symbol -), underscore (symbol _), or period (symbol .)")
            }
            
            if char.isLetter || char.isNumber || char == "-" || char == "_" || char == "." {
                continue
            }
            
            return (false, "\(title) handle can only contain alphanumeric characters (letters A-Z, numbers 0-9), hyphens (symbol -), underscores (symbol _), and periods (symbol .)")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let profileHandle = userInputs[.snapchatHandle], !profileHandle.isEmpty else { return nil }
        let data = "Snapchat.com/add/\(profileHandle)"
        
        return data
    }
}
