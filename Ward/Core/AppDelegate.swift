//
//  AppDelegate.swift
//  Ward
//
//  Created by Shadi Elattar on 9/21/21.
//

import UIKit
import SVProgressHUD
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        SVProgressHUD.setDefaultMaskType(.black)
        
        let mainTabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar")
        window?.rootViewController = mainTabBar
        
        
        print(UDHelper.token)
 //LoginVC
        
        
//        let LoginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
//        window?.rootViewController = LoginVC
        return true
    }


}

