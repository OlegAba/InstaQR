//
//  BitcoinCashBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class BitcoinCashBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .bitcoinCash)
        
        userInputs[.bitcoinCashAddress] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // cryptofacilities.zendesk.com/hc/en-us/articles/360006469814-BCH-CashAddr-Format
        
        let title = self.title ?? ""
        let sanitizedData = truncateCryptoIdentifier(data: data).trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 26 {
            return (false, "\(title) address must be at least 26 characters long")
        }
        
        if sanitizedData.count > 90 {
            return (false, "\(title) address cannot be longer than 90 characters")
        }
        
        if !(sanitizedData.first == "1" || sanitizedData.first == "q" || sanitizedData.first == "3" || sanitizedData.first == "p") {
            
            return (false, "\(title) address must begin with character \"1\", \"q\", \"3\", or \"p\"")
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
        guard let address = userInputs[.bitcoinCashAddress], !address.isEmpty else { return nil }
        let sanitizedAddress = truncateCryptoIdentifier(data: address)
        let data = "bitcoincash:\(sanitizedAddress)"
        
        return data
    }
}
