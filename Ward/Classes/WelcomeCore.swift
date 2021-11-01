//
//  WelcomeCore.swift
//  LimoTrip
//
//  Created by Elattar on 8/17/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import Foundation

class Core {
    static let shared = Core()
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: UDKeys.isNewUser)
    }
    
    func setIsNotNewUser(){
        UserDefaults.standard.set(true, forKey: UDKeys.isNewUser)
    }
}
