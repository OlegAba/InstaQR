//
//  FacebookBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class FacebookBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .facebook)
        
        userInputs[.facebookHandle] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        // facebook.com/help/409473442437047
        
        let title = self.title!
        let sanitizedData = data.trimmingCharacters(in: .whitespaces).lowercased()
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 5 {
            return (false, "\(title) handle must be at least 5 characters long")
        }
        
        if sanitizedData.count > 50 {
            return (false, "\(title) handle cannot be longer than 50 characters")
        }
        
        for char in sanitizedData {
            if char.isLetter || char.isNumber || char == "." {
                continue
            }
            
            return (false, "\(title) handle can only contain alphanumeric characters (letters A-Z, numbers 0-9) and periods (symbol .)")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let profileHandle = userInputs[.facebookHandle], !userInputs.isEmpty else { return nil }
        let data = "Facebook.com/\(profileHandle)"
        
        return data
    }
    
}
