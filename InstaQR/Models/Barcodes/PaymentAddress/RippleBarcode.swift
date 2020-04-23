//
//  RippleBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class RippleBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .ripple)
        
        userInputs[.rippleAddress] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // developers.ripple.com/accounts.html
        
        let title = self.title ?? ""
        let sanitizedData = truncateCryptoIdentifier(data: data).trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 25 {
            return (false, "\(title) address must be at least 25 characters long")
        }
        
        if sanitizedData.count > 35 {
            return (false, "\(title) address cannot be longer than 35 characters")
        }
        
        if sanitizedData.first != "r" {
            return (false, "\(title) address must begin with character \"r\"")
        }
        
        if sanitizedData.contains("0") {
            return (false, "\(title) address cannot contain the character \"0\"")
        }
        
        if sanitizedData.contains("O") {
            return (false, "\(title) address cannot contain the character \"O\"")
        }
        
        if sanitizedData.contains("I") {
            return (false, "\(title) address cannot contain the character \"I\"")
        }
        
        if sanitizedData.contains("l") {
            return (false, "\(title) address cannot contain the character \"l\"")
        }
        
        for char in sanitizedData {
            if char.isLetter || char.isNumber {
                continue
            }
            
            return (false, "\(title) address can only contain alphanumeric characters (letters A-Z, numbers 0-9)")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let address = userInputs[.rippleAddress], !address.isEmpty else { return nil }
        let sanitizedAddress = truncateCryptoIdentifier(data: address)
        let data = "ripple:\(sanitizedAddress)"
        
        return data
    }
}
