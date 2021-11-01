//
//  SizeCell.swift
//  Ward
//
//  Created by Shadi Elattar on 9/27/21.
//

import UIKit

class SizeCell: UICollectionViewCell {

    @IBOutlet weak var viewX: UIView!
    @IBOutlet weak var sizeTitle_lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        viewX.backgroundColor = .WGray
        sizeTitle_lbl.textColor = .black
        
    }

    
    override var isSelected: Bool{
        didSet{
            sizeTitle_lbl.textColor = isSelected ? UIColor.white : UIColor.black
            viewX.backgroundColor = isSelected ? UIColor.mainColor : UIColor.WGray
        }
    }
}
