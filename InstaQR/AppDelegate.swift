//
//  AppDelegate.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var newWallpaperNavigationController: NewWallpaperNavigationController?
    var onBoardingViewController: OnBoardingViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        if System.shared.isFirstTimeLaunching() {
            onBoardingViewController = OnBoardingViewController()
            window?.rootViewController = onBoardingViewController
        } else {
            newWallpaperNavigationController = NewWallpaperNavigationController()
            window?.rootViewController = newWallpaperNavigationController
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
