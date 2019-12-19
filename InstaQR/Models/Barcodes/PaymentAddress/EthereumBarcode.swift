//
//  EthereumBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class EthereumBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .ethereum)
        
        userInputs[.ethereumAddress] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // en.wikipedia.org/wiki/Ethereum#Addresses
        // reddit.com/r/ethereum/comments/6l3da1/how_long_are_ethereum_addresses/
        
        let title = self.title!
        let sanitizedData = truncateCryptoIdentifier(cryptoBarcodeTitle: title, data: data).trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count != 42 {
            return (false, "\(title) address must be 42 characters long")
        }
        
        let identifierIndex = sanitizedData.index(sanitizedData.startIndex, offsetBy: 2)
        if sanitizedData[..<identifierIndex] != "0x" {
            return (false, "\(title) address must begin with characters \"0x\"")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let address = userInputs[.ethereumAddress], !address.isEmpty else { return nil }
        let data = "ethereum:\(address)"
        
        return data
    }
}
