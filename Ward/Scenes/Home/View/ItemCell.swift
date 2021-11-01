//
//  ItemCell.swift
//  Ward
//
//  Created by Shadi Elattar on 9/21/21.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var itemImage_iv: UIImageView!
    @IBOutlet weak var itemName_lbl: UILabel!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var oldPrice_lbl: UILabel!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var rateView: RatingView!
    @IBOutlet weak var personalStackView: UIStackView!
    @IBOutlet weak var favBtn: UIButton!{
        didSet{
//            favBtn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
//            favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .selected)
        }
    }
    
    var favorite: ((Bool)->())?
    var addToCart: (()->())?
        
        
    override func awakeFromNib() {
        super.awakeFromNib()
   //     oldPrice_lbl.isHidden = true
        rateView.ConfigurasWithRating(rating: 3)
    }
    

    @IBAction func favoriteTapped(_ sender: UIButton) {
   //     print("Favorite Tapped")
        sender.checkboxAnimation {
            print(sender.isSelected)
             self.favorite?(sender.isSelected)
        }
       // favorite?()
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
      //  print("Add To Cart Tapped")
        addToCart?()
    }
}
