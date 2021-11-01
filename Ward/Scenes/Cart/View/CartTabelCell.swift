//
//  CartTabelCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/13/21.
//

import UIKit

class CartTabelCell: UITableViewCell {
    
    
    @IBOutlet weak var userImg_iv: CircleImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var productCollV: UICollectionView!
    
    var checkoutTapped: (()-> Void)?
    
    var product: [Cart_items]? {
        didSet {
            self.productCollV.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewConfiguration()
    }
    
    
    private func collectionViewConfiguration(){
       // CartCollCell
        productCollV.delegate = self
        productCollV.dataSource = self
        productCollV.registerNIB(CartCollCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func checkout_btn(_ sender: Any) {
        checkoutTapped?()
    }
    
}


extension CartTabelCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: CartCollCell.self, for: indexPath)
        let item = product?[indexPath.row]
        
        cell.itemImg_iv.getImage(imageUrl: item?.product?.imagePath ?? "")
        cell.itemName_lbl.text = item?.product?.name ?? ""
        cell.quantity_lbl.text = "Quantity: \(item?.quantity ?? 0)"
        cell.price_lbl.text = "\(item?.product?.price ?? 0) SR"
        
        let oldPrice = item?.product?.price_after_discount
        
        if item?.product?.price_after_discount == 0 {
            cell.oldPrice_lbl.isHidden = true
        }else{
            cell.oldPrice_lbl.isHidden = false
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(oldPrice?.rounded(toPlaces: 3) ?? 0.0)" + "SR")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.oldPrice_lbl.attributedText = attributeString
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width) / 2, height: collectionView.frame.height)
    }
    
}
