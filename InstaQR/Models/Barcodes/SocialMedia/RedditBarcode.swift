//
//  RedditBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class RedditBarcode: Barcode {
    
    init() {
        super.init(barcodeType: .reddit)
        
        userInputs[.redditHandle] = ""
    }
    
    override func userInputValidationFor(data: String, inputKeyType: BarcodeInput.KeyType) -> (isValid: Bool, errorMessage: String?) {
        // reddit.com/r/help/comments/2oa8cs/do_you_know_which_characters_are_allowed_in_a/
        // reddit.com/r/swtor/comments/lz4mx/what_are_the_minmax_character_limits_for_names/
        
        let title = self.title!
        let sanitizedData = data.trimmingCharacters(in: .whitespaces).lowercased()
        
        if sanitizedData.isEmpty {
            return (false, "This field cannot be empty")
        }
        
        if sanitizedData.count < 3 {
            return (false, "\(title) handle must be at least 3 characters long")
        }
        
        if sanitizedData.count > 15 {
            return (false, "\(title) hande cannot be longer than 15 characters")
        }
        
        for char in sanitizedData {
            if char.isLetter || char.isNumber || char == "-" || char == "_" {
                continue
            }
            
            return (false, "\(title) handle can only contain alphanumeric characters (letters A-Z, numbers 0-9), underscores (symbol _), and hyphen (symbol -)")
        }
        
        return (true, nil)
    }
    
    override func generateDataFromInputs() -> String? {
        guard let profileHandle = userInputs[.redditHandle], !profileHandle.isEmpty else { return nil }
        let data = "reddit.com/user/\(profileHandle)"
        
        return data
    }
}
