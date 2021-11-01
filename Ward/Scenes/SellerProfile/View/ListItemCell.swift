//
//  ListItemCell.swift
//  Ward
//
//  Created by Shadi Elattar on 9/28/21.
//

import UIKit

class ListItemCell: UITableViewCell {

    @IBOutlet weak var itemImg_iv: UIImageView!
    @IBOutlet weak var itemName_lbl: UILabel!
    @IBOutlet weak var old_price: UILabel!
    @IBOutlet weak var itemPrice_lbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    
    var addToCartTapped: (()->())?
    var addToFavourtie: ((Bool)->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func favuriteTapped(_ sender: UIButton) {
        sender.checkboxAnimation {
            print(sender.isSelected)
             self.addToFavourtie?(sender.isSelected)
        }
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        addToCartTapped?()
    }
    
}
