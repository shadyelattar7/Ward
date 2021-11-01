//
//  CategoryCell.swift
//  Ward
//
//  Created by Shadi Elattar on 9/22/21.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryTitle_lbl: UILabel!
    @IBOutlet weak var itemCollV: UICollectionView!
    
    var seeMore: (()->())?
    var addToCart: ((Int,Int)->())?
    var addToFavo: ((Int,Bool) -> Void)?
    var onCellTapped: ((Bestseller) -> Void)?
    
    
    
    var indexpathRow: Int = 0
    var subCategory: [Sub_categories]? {
        didSet {
            self.itemCollV.reloadData()
        }
    }

    var product: [Bestseller]? {
        didSet {
            self.itemCollV.reloadData()
        }
    }
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        itemCollV.delegate = self
        itemCollV.dataSource = self
        itemCollV.registerNIB(CategoryItemCell.self)
        itemCollV.registerNIB(ItemCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
    
    @IBAction func seeMoreTapped(_ sender: Any) {
        seeMore?()
    }
    
}

//MARK:- UICollectioView Configuration
extension CategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if indexpathRow == 0 {
            return product?.count ?? 0
        }else{
            return subCategory?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexpathRow == 0{ // BestSeller
            let cell = collectionView.dequeue(cell: ItemCell.self, for: indexPath)
            
            let bestseller = product?[indexPath.row]
            
            cell.itemImage_iv.getImage(imageUrl: bestseller?.imagePath ?? "")
            cell.itemName_lbl.text = bestseller?.name_en
            let price = bestseller?.price ?? 0.0
            cell.price_lbl.text = "\(price.rounded(toPlaces: 1)) SAR"
            let oldPrice = bestseller?.price_after_discount ?? 0.0
            
            cell.username_lbl.text = bestseller?.store?.user?.name ?? ""
            
            
            if bestseller?.price_after_discount == 0.0 {
                cell.oldPrice_lbl.isHidden = true
            }else{
                cell.oldPrice_lbl.isHidden = false
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(oldPrice.rounded(toPlaces: 3))" + "SAR")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.oldPrice_lbl.attributedText = attributeString
                
            }
            
           
            if bestseller?.in_wishlist == 0 {
                cell.favBtn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
            }else{
                cell.favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
            }
            
            cell.favorite = { [weak self] (status) in
                guard let self = self else {return}
                self.addToFavo?(bestseller?.id ?? 0,status)
                if UDHelper.token == "" {
                    print("not you authorized")
                }else{
                    print("nice you authorized")
                    print("Add To Favorite home")
                    
                    if bestseller?.in_wishlist == 0 {
                        if status == true{
                            cell.favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
                        }else{
                            cell.favBtn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
                        }
                    }else{
                        if status == true{
                            cell.favBtn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
                        }else{
                            cell.favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
                        }
                    }
                }
                
            }
            
            cell.addToCart = { [weak self] in
                guard let self = self else {return}
                print("Add To Cart home")
                self.addToCart?(bestseller?.id ?? 0, bestseller?.store_id ?? 0)
            }
            
            return cell
            
        }else{ // Category
            
            let cell = collectionView.dequeue(cell: CategoryItemCell.self, for: indexPath)
            
            let subCategory = subCategory?[indexPath.row]
            
            cell.itemName_lbl.text = subCategory?.name_en
            cell.itemImg_iv.getImage(imageUrl: subCategory?.image ?? "")
            return cell
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20) / 2  , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexpathRow == 0{
            guard let product = product?[indexPath.item] else { return }
            self.onCellTapped?(product)
        }else{
            print("Not Bestseller")
        }
       
    }
    
}
