//
//  TumblrBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class TumblrBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .tumblr)
        
        userInputs[.tumblrName] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        // unwrapping.tumblr.com/post/58535402323/tips-tumblr-username
        
        let title = self.title!
        let sanitizedData = data.trimmingCharacters(in: .whitespaces).lowercased()
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count > 32 {
            return (false, "\(title) name cannot be longer than 32 characters")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let name = userInputs[.tumblrName], !name.isEmpty else { return nil }
        let data = "\(name).Tumblr.com"
        
        return data
    }
}
