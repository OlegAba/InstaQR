//
//  EmailBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class EmailBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .email)
        
        userInputs[.genericEmail] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        let title = self.title ?? ""
        let sanitizedData = data.trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if !isValid(email: sanitizedData) {
            return (false, "The specified \(title) is invalid")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let data = userInputs[.genericEmail], !data.isEmpty else { return nil }
        return data
    }
    
    fileprivate func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
}
