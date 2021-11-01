//
//  ProductFormCategoryVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/4/21.
//

import UIKit
import SVProgressHUD

class ProductFormCategoryVC: UIViewController {

    @IBOutlet weak var viewTitle_lbl: UILabel!
    @IBOutlet weak var productCollV: UICollectionView!
    
    var product: [Bestseller] = []
    var categoryID: Int = 0
    var subCategoryID: Int = 0
    var categoryName: String = ""
    var storeID: Int = 0
    
    

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
        fetchMoreItemFromCategory(category_id: "\(categoryID)", subcategory_id: "\(subCategoryID)")
        CollectionViewConfiguration()
    }
    
    private func setupView(){
        viewTitle_lbl.text = categoryName
    }
    
    private func CollectionViewConfiguration(){
        productCollV.delegate = self
        productCollV.dataSource = self
        productCollV.registerNIB(ItemCell.self)
    }
    
    private func fetchMoreItemFromCategory(category_id: String, subcategory_id: String){
        SVProgressHUD.show()
        APIManagerSeeMore.getMoreItemFromCategroy(category_id: category_id, subcategory_id: subcategory_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Successfully get item from category")
                self.product = result.data?.products ?? []
                self.productCollV.reloadData()
            }else{
                print("Failure get item from category")
                print("Error Message: \(result.message ?? "")")
            }
        }
    }
    
    private func filterData(colorsID: [String],overall_rate: Int,lat: Double,lng: Double,priceFrom: Double,priceTo: Double,category_id: Int,subcategory_id: Int){
        SVProgressHUD.show()
        APIManagerFilter.getProductFromCategoryAfterFilter(colorsID: colorsID, overall_rate: overall_rate, user_lat: lat, user_lng: lng, price_from: priceFrom, price_to: priceTo, category_id: category_id, subcategory_id: subcategory_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("Successfully filter")
                self.product = result.data ?? []
                self.productCollV.reloadData()
            }else{
                print("Failure filter")
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
    
    @IBAction func filterTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

//MARK: UICollectionView Confugration
extension ProductFormCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
  
            let cell = collectionView.dequeue(cell: ItemCell.self, for: indexPath)
            
            let bestseller = product[indexPath.row]
            
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
        
        print("inWishList: \(inWishList)")
        
        if inWishList == 0 {
            cell.favBtn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
        }else{
            cell.favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
        }
            
            
        cell.favorite = { [weak self] (status) in
            guard let self = self else {return}
            print("Add To Favorite ZZ")
            if UDHelper.token == "" {
                QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
            }else{
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
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: (self.productCollV.frame.size.width - 20) / 2, height: 300)
      }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //ProductFormCategoryVC
        let sb = UIStoryboard(name: "ItemDetailes", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailesVC") as! ItemDetailesVC
        sb.product = product[indexPath.row]
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
}


extension ProductFormCategoryVC: FilterData{
    func filterProduct(rate: Int, color: [String], priceFrom: Double, priceTo: Double) {
        
        let lat = UDHelper.UserCoordinates.lat
        let lng = UDHelper.UserCoordinates.long
        
        filterData(colorsID: color, overall_rate: rate, lat: lat, lng: lng, priceFrom: priceFrom, priceTo: priceTo, category_id: 1, subcategory_id: 0)
    }
    
    
}
