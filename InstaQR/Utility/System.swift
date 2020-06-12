//
//  System.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class System {
    
    static let shared = System()
    
    let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    let globalInset: CGFloat = 15.0
    let globalCornerRadius: CGFloat = 15.0
    let globalOpacity: CGFloat = 0.5
    
    fileprivate let defaults = UserDefaults.standard
    fileprivate let firstTimeKey = "isFirstTime"
    
    func appDelegate() -> AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return AppDelegate() }
        return appDelegate
    }
    
    func isFirstTimeLaunching() -> Bool {
        return (defaults.object(forKey: firstTimeKey) == nil)
    }
    
    func firstTimeLaunchingFinished() {
        defaults.set(true, forKey: firstTimeKey)
    }
    
    func triggerFeedbackGenerator() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    func openAppSettingsUrl() -> Void {
        
        func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
            return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
        }
        
        guard let settingsUrl = NSURL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}
