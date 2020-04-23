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
        
        let title = self.title ?? ""
        let sanitizedData = data.trimmingCharacters(in: .whitespaces)
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if !isValidUrl(url: sanitizedData) {
            return (false, "The specified \(title) URL is invalid")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let data = userInputs[.genericUrl], !data.isEmpty else { return nil }
        return data
    }
    
    // stackoverflow.com/questions/29106005/url-validation-in-swift
    fileprivate func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
}
