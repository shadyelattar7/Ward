//
//  AlertToLogin.swift
//  Ward
//
//  Created by Shadi Elattar on 10/12/21.
//

import Foundation
import UIKit

class QuickAlert {
    static func showWith(message: String, in viewConroller: UIViewController) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let signInAction: UIAlertAction = .init(title: "Login", style: .default) { (ـ) in
            let signinVC = UIStoryboard(name: "Auth", bundle: nil)
                .instantiateViewController(withIdentifier: "AuthNav")
            //viewConroller.navigationController?.pushViewController(signinVC, animated: true)
            viewConroller.present(signinVC, animated: true, completion: nil)
        }
        let cancelAction: UIAlertAction = .init(title: "Cancel", style: .cancel)
        
        alertVC.addAction(signInAction)
        alertVC.addAction(cancelAction)
        viewConroller.present(alertVC, animated: true)
    }
}
