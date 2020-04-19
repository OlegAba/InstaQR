//
//  ViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 4/18/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // NOTE: Returns true if the present device has a home button (Older devices)
        if !(view.safeAreaInsets.bottom > 0) {
            additionalSafeAreaInsets.bottom = 15.0
        }
    }
}
