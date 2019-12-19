//
//  LinkedinBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class LinkedinBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .linkedin)
        
        userInputs[.linkedinHandle] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        // linkedin.com/help/linkedin/answer/87/customizing-your-public-profile-url?lang=en
        
        let title = self.title!
        let sanitizedData = data.trimmingCharacters(in: .whitespaces).lowercased()
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 5 {
            return (false, "\(title) handle must be at least 5 characters long")
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
        guard let profileHandle = userInputs[.linkedinHandle], !profileHandle.isEmpty else { return nil }
        let data = "Linkedin.com/in/\(profileHandle)"
        
        return data
    }
}
