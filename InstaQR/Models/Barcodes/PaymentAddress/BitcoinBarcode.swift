//
//  BitcoinBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class BitcoinBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .bitcoin)
        
        userInputs[.bitcoinAddress] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // en.bitcoin.it/wiki/Address
        
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
        
        // Check if the address matches any of the 3 bitcoin address formats (P2PKH, P2SH, Bech32)
        let bech32Index = sanitizedData.index(sanitizedData.startIndex, offsetBy: 3)
        if !((sanitizedData.first == "1") || (sanitizedData.first == "3") || (sanitizedData[..<bech32Index] == "bc1")) {
            return (false, "\(title) address must begin with character/s \"1\", \"3\", or \"bc1\"")
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
        guard let address = userInputs[.bitcoinAddress], !address.isEmpty else { return nil }
        let sanitizedAddress = truncateCryptoIdentifier(data: address)
        let data = "bitcoin:\(sanitizedAddress)"
        
        return data
    }
}
