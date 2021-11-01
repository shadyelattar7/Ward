//
//  OrderItemTableCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/19/21.
//

import UIKit

class OrderItemTableCell: UITableViewCell {

    @IBOutlet weak var item_iv: UIImageView!
    @IBOutlet weak var itemname_lbl: UILabel!
    @IBOutlet weak var quantity_lbl: UILabel!
    @IBOutlet weak var descripation_lbl: UILabel!
    @IBOutlet weak var itemPrice_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
