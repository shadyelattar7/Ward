//
//  UITextField+Extensions.swift
//  Models
//
//  Created by Ayman Ata on 1/12/21.
//  Copyright © 2021 Elattar. All rights reserved.
//

import UIKit

extension UITextField {
    
    func set(padding: CGFloat = 16, corner: CGFloat = 12) {
       
        let leftViewWidth = padding
        
        let leftView = UIView(frame: CGRect(x: 0, y: frame.height/2, width: leftViewWidth, height: frame.height))
        
        self.leftView = leftView
        self.leftViewMode = .always
        
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
        layer.borderWidth = 1
//        layer.borderColor = UIColor.MDWhite.cgColor
        
        textColor = .darkGray
        font = UIFont.systemFont(ofSize: 17)
//        backgroundColor = .MDWhite
    }
    
}
