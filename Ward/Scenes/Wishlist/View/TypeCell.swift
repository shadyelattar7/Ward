//
//  TypeCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/20/21.
//

import UIKit

class TypeCell: UICollectionViewCell {

    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title_lbl.textColor = .WGray
        
    }
    
    override var isSelected: Bool{
        didSet{
            title_lbl.textColor = isSelected ? UIColor.mainColor : UIColor.WGray
            lineView.backgroundColor = isSelected ? UIColor.mainColor : UIColor.WGray
        }
    }

}
