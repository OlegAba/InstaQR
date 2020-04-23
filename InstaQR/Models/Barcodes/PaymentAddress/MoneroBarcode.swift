//
//  MoneroBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class MoneroBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .monero)
        
        userInputs[.moneroAddress] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // monero.fandom.com/wiki/Address_validation
        
        let title = self.title ?? ""
        let sanitizedData = truncateCryptoIdentifier(data: data).trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count == 95 {
            let firstChar = sanitizedData.first
            let secondIndex = sanitizedData.index(sanitizedData.startIndex, offsetBy: 1)
            let secondChar = sanitizedData[secondIndex]
            
            if firstChar != "4" {
                return (false, "\(title) address must begin with the character \"4\"")
            }
            
            if !(secondChar.isNumber || secondChar == "A" || secondChar == "B") {
                return (false, "The second character of a \(title) address must be a number, or the letter \"A\" or \"B\"")
            }
            
            return (true, nil)
            
        } else if sanitizedData.count == 106 {
            return (true, nil)
        }
        
        return (false, "\(title) address must be 95 or 106 characters long")
    }
    
    override func generateDataFromInputs() -> String? {
        guard let address = userInputs[.moneroAddress], !address.isEmpty else { return nil }
        let sanitizedAddress = truncateCryptoIdentifier(data: address)
        let data = "monero:\(sanitizedAddress)"
        
        return data
    }
}
