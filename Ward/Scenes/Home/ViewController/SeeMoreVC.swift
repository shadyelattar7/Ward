//
//  SeeMoreVC.swift
//  Ward
//
//  Created by Shadi Elattar on 9/22/21.
//

import UIKit
import SVProgressHUD

class SeeMoreVC: UIViewController {
    
    @IBOutlet weak var collV: UICollectionView!
    @IBOutlet weak var filter_btn: UIButton!
    @IBOutlet weak var title_lbl: UILabel!
    
    
    var isBestselling: Bool = false
    var bestSelllerSeeMore: [Bestseller] = []
   
    var subCategory: [Sub_categories] = []
    var categoryID: Int = 0
   
    var subCategoryName: String = ""
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        collectionViewConfiguration()
        if isBestselling{
            title_lbl.text = "Bestselling"
            fetchBestSellerSeeMore()
            filter_btn.isHidden = false
        }else{
            fetchMoreCategory(id: categoryID)
            title_lbl.text = subCategoryName
            filter_btn.isHidden = true
        }
    }
    
    
    private func setupView(){
      
   
    }
    
    private func collectionViewConfiguration(){
        collV.delegate = self
        collV.dataSource = self
        collV.registerNIB(ItemCell.self)
        collV.registerNIB(CategoryItemCell.self)
    }
    
    private func fetchBestSellerSeeMore(){
        SVProgressHUD.show()
        APIManagerSeeMore.getBestSellerSeeMore { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Successfully get best seller see more data")
                self.bestSelllerSeeMore = result.data ?? []
                self.collV.reloadData()
            }else{
                print("Failure get best seller see more data")
            }
        }
    }
    
    private func fetchMoreCategory(id: Int){
        SVProgressHUD.show()
        APIManagerSeeMore.getCategorySeeMore(id: "\(id)") { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Successfully get more sub category")
                self.subCategory = result.data ?? []
                self.collV.reloadData()
            }else{
                print("Failure get more sub category")
            }
        }
    }
    
    private func addToCart(product_id: Int,store_id: Int){
        SVProgressHUD.show()
        APIManagerAddToCart.addToCart(product_id: product_id, store_id: store_id, quantity: 1, sizeId: 1, cart_color_ids: [1]) { result in
            SVProgressHUD.dismiss()
            if result.status == 201{
                ToastManager.shared.showToast(message: "The operation was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
            }else{
                print("ERRORS: \(result.errors ?? [])")
                print("Messages: \(result.messages ?? [])")
                ToastManager.shared.showToast(message: result.errors?[0] ?? "", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
    
    private func addToWishlist(product_id: Int){
        SVProgressHUD.show()
        APIManagerAddToWishlist.addToWishlist(product_id: product_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 201{
                ToastManager.shared.showToast(message: "The operation was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
            }else{
                print("ERRORS: \(result.errors ?? [])")
                print("Messages: \(result.messages ?? [])")
                ToastManager.shared.showToast(message: result.message ?? "", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
    
    private func removeFromWishlist(product_id: Int){
        SVProgressHUD.show()
        APIManagerAddToWishlist.deleteFromWishlist(product_id: product_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                ToastManager.shared.showToast(message: "The remove to wishlist was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
            }else{
                print("ERRORS: \(result.errors ?? [])")
                print("Messages: \(result.messages ?? [])")
                ToastManager.shared.showToast(message: result.message ?? "", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }

    private func filterData(colorsID: [String],overall_rate: Int,lat: Double,lng: Double,priceFrom: Double,priceTo: Double,selling: Int){
        SVProgressHUD.show()
        APIManagerFilter.getProductAfterFilter(colorsID: colorsID, overall_rate: overall_rate, user_lat: lat, user_lng: lng, price_from: priceFrom, price_to: priceTo, selling: selling) { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("Successfully filter")
                self.bestSelllerSeeMore = result.data ?? []
                self.collV.reloadData()
            }else{
                print("Failure filter")
            }
        }
    }
    @IBAction func filterTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        sb.delegate = self
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UICollectionView Confugration
extension SeeMoreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isBestselling{
            return bestSelllerSeeMore.count
        }else{
            return subCategory.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isBestselling{
            let cell = collectionView.dequeue(cell: ItemCell.self, for: indexPath)
            
            let bestseller = bestSelllerSeeMore[indexPath.row]
            
         //   let title = "lang".localized == "en" ? product.name_en : product.name_ar
            
          
            
            cell.itemImage_iv.getImage(imageUrl: bestseller.imagePath ?? "")
            cell.itemName_lbl.text = bestseller.name_en
            let price = bestseller.price ?? 0.0
            cell.price_lbl.text = "\(price.rounded(toPlaces: 1)) SAR"
            let oldPrice = bestseller.price_after_discount ?? 0.0
            
            cell.username_lbl.text = bestseller.store?.user?.name ?? ""
            
            
            if bestseller.price_after_discount == 0.0 {
                cell.oldPrice_lbl.isHidden = true
            }else{
                cell.oldPrice_lbl.isHidden = false
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(oldPrice.rounded(toPlaces: 3))" + "SAR")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.oldPrice_lbl.attributedText = attributeString
                
            }
            
            let inWishList = bestseller.in_wishlist ?? 0
            if inWishList == 0 {
                cell.favBtn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
            }else{
                cell.favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
            }
            
            cell.favorite = { [weak self] (status)in
                guard let self = self else {return}
                print("Add To Favorite ZZ")
                if UDHelper.token == "" {
                    QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
                }else{
                    print("nice you authorized")
                    let inWishList = bestseller.in_wishlist ?? 0
                   
                    if inWishList == 0{
                        if status == true{
                            print("Add To WishList")
                            self.addToWishlist(product_id: bestseller.id ?? 0)
                            cell.favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
                        }else{
                            print("delete from WishList")
                            self.removeFromWishlist(product_id: bestseller.id ?? 0)
                            cell.favBtn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
                        }
                    }else{
                        if status == true{
                            print("delete from WishList")
                            self.removeFromWishlist(product_id: bestseller.id ?? 0)
                            cell.favBtn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
                        }else{
                            print("Add To WishList")
                            self.addToWishlist(product_id: bestseller.id ?? 0)
                            cell.favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
                        }
                    }
                
                }
            }
            
            cell.addToCart = { [weak self] in
                guard let self = self else {return}
                
                if UDHelper.token == "" {
                    QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
                }else{
                    print("nice you authorized")
                    self.addToCart(product_id: bestseller.id ?? 0, store_id: bestseller.store_id ?? 0)
                }
                
            }
            return cell
        }else{
            let cell = collectionView.dequeue(cell: CategoryItemCell.self, for: indexPath)
            let subCategory = subCategory[indexPath.row]
            cell.itemImg_iv.getImage(imageUrl: subCategory.image ?? "")
            cell.itemName_lbl.text = subCategory.name_en
            return cell
        }
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: (self.collV.frame.size.width - 20) / 2, height: 300)
      }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //ProductFormCategoryVC
        
        if isBestselling{
            print("Is Bestselling")
            let sb = UIStoryboard(name: "ItemDetailes", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailesVC") as! ItemDetailesVC
            sb.product = bestSelllerSeeMore[indexPath.row]
            self.navigationController?.pushViewController(sb, animated: true)
        }else{
            let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProductFormCategoryVC") as! ProductFormCategoryVC
            sb.categoryID = subCategory[indexPath.row].category_id ?? 0
            sb.subCategoryID = subCategory[indexPath.row].id ?? 0
            sb.categoryName = subCategory[indexPath.row].name_en ?? ""
            self.navigationController?.pushViewController(sb, animated: true)
        }
        
    }
    
}


extension SeeMoreVC: FilterData{
    func filterProduct(rate: Int, color: [String], priceFrom: Double, priceTo: Double) {
        print("Rate: \(rate), Color: \(color), PriceFrom: \(priceFrom), PriceTo: \(priceTo)")
        let lat = UDHelper.UserCoordinates.lat
        let lng = UDHelper.UserCoordinates.long
        
        filterData(colorsID: color, overall_rate: rate, lat: lat, lng: lng, priceFrom: priceFrom, priceTo: priceTo, selling: 1)
        
    }
    
    
}
