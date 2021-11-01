//
//  ChoessCell.swift
//  Ward
//
//  Created by Shadi Elattar on 9/27/21.
//

import UIKit

class ChoessCell: UICollectionViewCell {

    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title_lbl.textColor = .WGray
        lineView.isHidden = true
    }

    
    override var isSelected: Bool{
        didSet{
            title_lbl.textColor = isSelected ? UIColor.mainColor : UIColor.WGray
            lineView.isHidden = isSelected ? false : true
        }
    }
    
}
