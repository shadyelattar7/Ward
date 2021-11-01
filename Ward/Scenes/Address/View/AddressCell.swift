//
//  AddressCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/19/21.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var city_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var check_iv: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
