//
//  PaypalBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class PaypalBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .paypal)
        
        userInputs[.paypalMerchantID] = ""
    }
    
    override func generateDataFromInputs() -> String? {
        guard let merchantId = userInputs[.paypalMerchantID], !merchantId.isEmpty else { return nil }
        let data = "paypal://options_details_social_profile?id=\(merchantId)"
        
        return data
    }
}
