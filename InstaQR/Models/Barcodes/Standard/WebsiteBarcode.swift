//
//  WebsiteBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class WebsiteBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .website)
        
        userInputs[.genericUrl] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        
        let title = self.title!
        let sanitizedData = data.trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        let canOpenUrl: Bool = {
            guard let url = URL(string: data) else { return false }
            return UIApplication.shared.canOpenURL(url)
        }()
        
        
        if !canOpenUrl {
            return (false, "The specified \(title) URL is invalid")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let data = userInputs[.genericUrl], !data.isEmpty else { return nil }
        return data
    }
}
