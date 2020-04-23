//
//  CashBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class CashBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .cash)
        
        userInputs[.cashTag] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        // cash.app/help/gb/en-gb/5504-cashtag-requirements
        
        let title = self.title ?? ""
        let sanitizedData = data.trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count > 20 {
            return (false, "\(title) tag cannot be longer than 20 characters")
        }
        
        for char in sanitizedData {
            if char.isLetter {
                break
            }
            
            return (false, "\(title) tag must contain at least 1 letter (A-Z)")
        }
        
        return(true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let cashTag = userInputs[.cashTag], !cashTag.isEmpty else { return nil }
        let data = "cash.me/$\(cashTag)"
        
        return data
    }
}
