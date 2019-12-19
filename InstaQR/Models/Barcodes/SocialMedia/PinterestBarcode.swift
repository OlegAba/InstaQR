//
//  PinterestBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class PinterestBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .pinterest)
        
        userInputs[.pinterestHandle] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        // help.pinterest.com/en/article/edit-your-profile
        
        let title = self.title!
        let sanitizedData = data.trimmingCharacters(in: .whitespaces).lowercased()
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 3 {
            return (false, "\(title) handle must be at least 3 characters long")
        }
        
        if sanitizedData.count > 30 {
            return (false, "\(title) hande cannot be longer than 30 characters")
        }
        
        for char in sanitizedData {
            if char.isLetter || char.isNumber {
                continue
            }
            
            return (false, "\(title) handle can only contain alphanumeric characters (letters A-Z, numbers 0-9)")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let profileHandle = userInputs[.pinterestHandle], !profileHandle.isEmpty else { return nil }
        let data = "Pinterest.com/\(profileHandle)"
        
        return data
    }
}
