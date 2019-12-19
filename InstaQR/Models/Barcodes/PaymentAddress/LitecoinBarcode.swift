//
//  LitecoinBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class LitecoinBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .litecoin)
        
        userInputs[.litecoinAddress] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        // cryptonomist.ch/en/2018/09/29/bitcoin-and-litecoin/
        
        let title = self.title!
        let sanitizedData = truncateCryptoIdentifier(cryptoBarcodeTitle: title, data: data).trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 26 {
            return (false, "\(title) address must be at least 26 characters long")
        }
        
        if sanitizedData.count > 35 {
            return (false, "\(title) address cannot be longer than 35 characters")
        }
        
        // Checking if the address matches any of the 3 litecoin address formats (P2PKH, P2SH, Bech32)
        // Old P2SH format uses 3, New P2SH format uses M
        let bech32Index = sanitizedData.index(sanitizedData.startIndex, offsetBy: 3)
        if !((sanitizedData.first == "L") || (sanitizedData.first == "M") || (sanitizedData.first == "3") || (sanitizedData[..<bech32Index] == "ltc1")) {
            return (false, "\(title) address must begin with character/s \"L\", \"M\", \"3\", or \"ltc1\"")
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
        guard let address = userInputs[.litecoinAddress], !address.isEmpty else { return nil }
        let data = "litecoin:\(address)"
        
        return data
    }
}
