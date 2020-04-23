//
//  VenmoBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class VenmoBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .venmo)
        
        userInputs[.venmoUsername] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // help.venmo.com/hc/en-us/articles/235432448-Check-or-Edit-Your-Username
        
        let title = self.title ?? ""
        let sanitizedData = data.trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 5 {
            return (false, "\(title) username must be at least 5 characters long")
        }
        
        if sanitizedData.count > 16 {
            return (false, "\(title) username cannot be longer than 15 characters")
        }
        
        for char in sanitizedData {
            
            if char.isLetter || char.isNumber || char == "-" || char == "_" {
                continue
            }
            
            return (false, "\(title) username can only contain alphanumeric characters (letters A-Z, numbers 0-9), hyphens (symbol -), and underscores (symbol _)")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let username = userInputs[.venmoUsername], !username.isEmpty else { return nil }
        let data = "venmo://paycharge?txn=pay&recipients=\(username)"
        
        return data
    }
}
