//
//  CustomBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class CustomBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .custom)
        
        userInputs[.genericNote] = ""
    }
    
    override func generateDataFromInputs() -> String? {
        guard let data = userInputs[.genericNote], !data.isEmpty else { return nil }
        return data
    }
}
