//
//  Helper.swift
//  Ward
//
//  Created by Shadi Elattar on 9/28/21.
//

import Foundation
import UIKit

class UDHelper {
    private static let userDefaults = UserDefaults.standard
    
    //    static func restartApp() {
    //        guard let window = UIApplication.shared.keyWindow else {return}
    //        let sb = UIStoryboard(name: "Main", bundle: nil)
    //        var vc: UIViewController
    //        if token.isEmpty {
    //            vc = sb.instantiateInitialViewController()!
    //        }else{
    //            vc = sb.instantiateViewController(withIdentifier: "MainTabBar")
    //            vc.dismiss(animated: true, completion: nil)
    //        }
    //        window.rootViewController = vc
    //        UIView.transition(with: window, duration: 0.5, options: .curveEaseIn, animations: nil, completion: nil)
    //    }
    
    static func restartApp() {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            if token.isEmpty {
                print("Not found token")
            }else{
                topController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    static func resetKeysWithoutLogoutAPI(){
        userDefaults.removeObject(forKey: UDKeys.token)
        userDefaults.removeObject(forKey: UDKeys.fcmToken)
        userDefaults.removeObject(forKey: UDKeys.phone)
        userDefaults.removeObject(forKey: UDKeys.name)
        userDefaults.removeObject(forKey: UDKeys.mail)
        userDefaults.removeObject(forKey: UDKeys.address)
        userDefaults.removeObject(forKey: UDKeys.imagePath)
        userDefaults.removeObject(forKey: UDKeys.description)
        userDefaults.removeObject(forKey: UDKeys.userID)
        userDefaults.removeObject(forKey: UDKeys.userType)
        userDefaults.removeObject(forKey: UDKeys.latitude)
        userDefaults.removeObject(forKey: UDKeys.longitude)
        userDefaults.removeObject(forKey: UDKeys.active)
        userDefaults.removeObject(forKey: UDKeys.addressID)

        
        guard let window = UIApplication.shared.keyWindow else {return}
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar")
        window.rootViewController = sb
        UIView.transition(with: window, duration: 0.5, options: .curveEaseIn, animations: nil, completion: nil)
  
    }
    
    static var token: String {
        set {
            userDefaults.set(newValue, forKey: UDKeys.token)
            restartApp()
        }
        get { userDefaults.string(forKey: UDKeys.token) ?? "" }
    }
    
    static var fcmToken: String {
        set { userDefaults.set(newValue, forKey: UDKeys.fcmToken) }
        get { userDefaults.string(forKey: UDKeys.fcmToken) ?? "" }
    }
    
    static var phone: String {
        set { userDefaults.set(newValue, forKey: UDKeys.phone) }
        get { userDefaults.string(forKey: UDKeys.phone) ?? "" }
    }
    
    static var name: String {
        set { userDefaults.set(newValue, forKey: UDKeys.name) }
        get { userDefaults.string(forKey: UDKeys.name) ?? "" }
    }
    
    static var mail: String {
        set { userDefaults.set(newValue, forKey: UDKeys.mail) }
        get { userDefaults.string(forKey: UDKeys.mail) ?? "" }
    }
    
    static var address: String {
        set { userDefaults.set(newValue, forKey: UDKeys.address) }
        get { userDefaults.string(forKey: UDKeys.address) ?? "" }
    }
    
    static var imagePath: String {
        set { userDefaults.set(newValue, forKey: UDKeys.imagePath) }
        get { userDefaults.string(forKey: UDKeys.imagePath) ?? "" }
    }
    
    static var description: String {
        set { userDefaults.set(newValue, forKey: UDKeys.description) }
        get { userDefaults.string(forKey: UDKeys.description) ?? "" }
    }
    
    static var userID: Int {
        set { userDefaults.set(newValue, forKey: UDKeys.userID) }
        get { userDefaults.integer(forKey: UDKeys.userID) }
    }
    
    static var userType: Int {
        set { userDefaults.set(newValue, forKey: UDKeys.userType) }
        get { userDefaults.integer(forKey: UDKeys.userType) }
    }
    
    static var active: Int {
        set { userDefaults.set(newValue, forKey: UDKeys.active) }
        get { userDefaults.integer(forKey: UDKeys.active) }
    }
    
    static var addressID: Int {
        set { userDefaults.set(newValue, forKey: UDKeys.addressID) }
        get { userDefaults.integer(forKey: UDKeys.addressID) }
    }
    
    static var UserCoordinates: (lat: Double, long: Double) {
        set {
            userDefaults.set(newValue.lat, forKey: UDKeys.latitude)
            userDefaults.set(newValue.long, forKey: UDKeys.longitude)
        }
        get {
            let lat = userDefaults.double(forKey: UDKeys.latitude)
            let long = userDefaults.double(forKey: UDKeys.longitude)
            return (lat, long)
        }
    }
    
    static var UserAddressExist: Bool{
        set {userDefaults.set(newValue, forKey: UDKeys.UserAddressExist)}
        get {userDefaults.bool(forKey: UDKeys.UserAddressExist)}
    }
    
}
