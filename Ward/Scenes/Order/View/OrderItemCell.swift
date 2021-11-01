//
//  OrderItemCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/18/21.
//

import UIKit

class OrderItemCell: UICollectionViewCell {

    @IBOutlet weak var item_iv: UIImageView!
    @IBOutlet weak var itemName_lbl: UILabel!
    @IBOutlet weak var quantity_lbl: UILabel!
    @IBOutlet weak var status_lbl: UILabel!
    @IBOutlet weak var statusColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusColorView.setView(corner: 4)
    }

}
