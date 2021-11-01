//
//  RateCell.swift
//  Ward
//
//  Created by Shadi Elattar on 9/26/21.
//

import UIKit

class RateCell: UITableViewCell {

    @IBOutlet weak var rateImag_iv: UIImageView!
    @IBOutlet weak var rateText_lbl: UILabel!
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
