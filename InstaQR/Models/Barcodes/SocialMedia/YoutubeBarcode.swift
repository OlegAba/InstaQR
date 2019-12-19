//
//  YoutubeBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class YoutubeBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .youtube)
        
        userInputs[.youtubeChannelName] = ""
    }
    
    override func generateDataFromInputs() -> String? {
        guard let channelName = userInputs[.youtubeChannelName], !channelName.isEmpty else { return nil }
        let data = "Youtube.com/user/\(channelName)"
        
        return data
    }
}
