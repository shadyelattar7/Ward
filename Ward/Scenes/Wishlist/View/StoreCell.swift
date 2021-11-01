//
//  StoreCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/26/21.
//

import UIKit

class StoreCell: UICollectionViewCell {

    @IBOutlet weak var userImage_iv: UIImageView!
    @IBOutlet weak var username_lbl: UILabel!

    
    var faveTapped: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }
    
    @IBAction func fave_btn(_ sender: Any) {
        faveTapped?()
    }
    
}
