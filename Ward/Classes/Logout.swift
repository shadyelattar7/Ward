//
//  Logout.swift
//  Tagwed
//
//  Created by admin on 11/23/19.
//  Copyright © 2019 Tagwed. All rights reserved.
//

import Foundation

class Logout {
    
    static func logout(completion: @escaping () -> () )
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
