//
//  CartCollCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/13/21.
//

import UIKit

class CartCollCell: UICollectionViewCell {

    @IBOutlet weak var itemImg_iv: UIImageView!
    @IBOutlet weak var itemName_lbl: UILabel!
    @IBOutlet weak var quantity_lbl: UILabel!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var oldPrice_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

}
