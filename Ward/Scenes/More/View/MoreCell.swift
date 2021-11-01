//
//  MoreCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/18/21.
//

import UIKit

class MoreCell: UITableViewCell {

    @IBOutlet weak var moreIcon_iv: UIImageView!
    @IBOutlet weak var itemName_lbl: UILabel!
    
    @IBOutlet weak var chatCounterView: UIView!
    @IBOutlet weak var chatCounter_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatCounterView.setView(corner: 10)
        chatCounterView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
