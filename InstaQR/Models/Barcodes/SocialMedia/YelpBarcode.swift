//
//  YelpBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class YelpBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .yelp)
        
        userInputs[.yelpUserID] = ""
    }
    
    override func generateDataFromInputs() -> String? {
        guard let userID = userInputs[.yelpUserID], !userID.isEmpty else { return nil }
        let data = "Yelp.com/user_details?userid=\(userID)"
        
        return data
    }
}
