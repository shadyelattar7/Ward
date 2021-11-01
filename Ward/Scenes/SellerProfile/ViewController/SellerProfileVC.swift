//
//  SellerProfileVC.swift
//  Ward
//
//  Created by Shadi Elattar on 9/28/21.
//

import UIKit
import SVProgressHUD

class SellerProfileVC: UIViewController {
    
    @IBOutlet weak var coverImg_iv: UIImageView!
    @IBOutlet weak var profilerpic_iv: UIImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var rateView: RatingView!
    @IBOutlet weak var grid_btn: UIButton!
    @IBOutlet weak var list_btn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fave_btn: UIButton!
    
    var user: User?
    var storeID: Int = 0
    var product: [Bestseller] = []
    
    var isClicked: Bool = false
    
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
        tableViewConfiguration()
        collectionViewConfiguration()
        showData()
        getStoreProduct()
       // print("Store ID: \(storeID)")
    }
    
    private func setupView(){
        rateView.ConfigurasWithRating(rating: 4)
        grid_btn.setImage(#imageLiteral(resourceName: "Group 58325"), for: .normal)
        list_btn.setImage(#imageLiteral(resourceName: "Group 58329"), for: .normal)
        collectionView.isHidden = false
        tableView.isHidden = true
    }
    
    private func tableViewConfiguration(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNIB(cell: ListItemCell.self)
    }
    
    private func collectionViewConfiguration(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNIB(ItemCell.self)
    }
    
    private func showData(){
        profilerpic_iv.getImage(imageUrl: user?.imagePath ?? "")
        username_lbl.text = user?.name ?? ""
    }
    
    
    private func getStoreProduct(){
        SVProgressHUD.show()
        APIManagerStoreProduct.getStoreProduct(storeID: storeID) { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Successfully get store product")
                self.product = result.data ?? []
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }else{
                print("Failure get store product")
            }
        }
    }
    
    private func filterData(colorsID: [String],overall_rate: Int,lat: Double,lng: Double,priceFrom: Double,priceTo: Double,selling: Int){
        SVProgressHUD.show()
        APIManagerFilter.getFilterInStore(colorsID: colorsID, overall_rate: overall_rate, user_lat: lat, user_lng: lng, price_from: priceFrom, price_to: priceTo, selling: selling, storeID: storeID) { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("Successfully filter")
                self.product = result.data ?? []
                self.collectionView.reloadData()
                self.tableView.reloadData()
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

    private func sellerAddToWishlist(store_id: Int){
        SVProgressHUD.show()
        APIManagerAddToWishlist.addSellerToWishlist(store_id: store_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 201{
                ToastManager.shared.showToast(message: "Add seller from wishlist was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
                self.fave_btn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
            }else{
                print("ERRORS: \(result.errors ?? [])")
                print("Messages: \(result.messages ?? [])")
                ToastManager.shared.showToast(message: result.message ?? "", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
    
    private func removeSellerFromWishlist(product_id: Int){
        SVProgressHUD.show()
        APIManagerAddToWishlist.deleteSellerFromWishlist(product_id: product_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                ToastManager.shared.showToast(message: "Remove seller from wishlist was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
                self.fave_btn.setImage(#imageLiteral(resourceName: "Group 58299"), for: .normal)
            }else{
                print("ERRORS: \(result.errors ?? [])")
                print("Messages: \(result.messages ?? [])")
                ToastManager.shared.showToast(message: result.message ?? "", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
  

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        sb.delegate = self
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        if UDHelper.token == "" {
            QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
        }else{
            print("nice you authorized")
            sellerAddToWishlist(store_id: storeID)
      
//            if isClicked{
//                isClicked = true
//                sellerAddToWishlist(store_id: storeID)
//            }else{
//                isClicked = false
//                removeSellerFromWishlist(product_id: storeID)
//            }
            
            
            
        }
    }
    
    @IBAction func gridTapped(_ sender: Any) {
        grid_btn.setImage(#imageLiteral(resourceName: "Group 58325"), for: .normal)
        list_btn.setImage(#imageLiteral(resourceName: "Group 58329"), for: .normal)
        collectionView.isHidden = false
        tableView.isHidden = true
    }
    
    @IBAction func listTapped(_ sender: Any) {
        grid_btn.setImage(#imageLiteral(resourceName: "unselectedGroup 58325"), for: .normal)
        list_btn.setImage(#imageLiteral(resourceName: "selectedGroup 58329"), for: .normal)
        collectionView.isHidden = true
        tableView.isHidden = false
    }
}


//MARK: UITableView Configuration
extension SellerProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! ListItemCell
        let bestseller = product[indexPath.row]
        cell.itemImg_iv.getImage(imageUrl: bestseller.imagePath ?? "")
        //   let title = "lang".localized == "en" ? product.name_en : product.name_ar
        cell.itemName_lbl.text = bestseller.name_en
        let price = bestseller.price ?? 0.0
        cell.itemPrice_lbl.text = "\(price.rounded(toPlaces: 1)) SAR"
        let oldPrice = bestseller.price_after_discount ?? 0.0
        
        if bestseller.price_after_discount == 0.0 {
            cell.old_price.isHidden = true
        }else{
            cell.old_price.isHidden = false
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(oldPrice.rounded(toPlaces: 3))" + "SAR")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.old_price.attributedText = attributeString
            
        }
        
        cell.addToFavourtie = { [weak self] status in
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
        
        cell.addToCartTapped = { [weak self] in
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}


//MARK: UICollectionView Configuration
extension SellerProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: ItemCell.self, for: indexPath)
        cell.personalStackView.isHidden = true
        
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
    }
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: (collectionView.frame.width - 20) / 2  , height: collectionView.frame.height / 2)
    }
    
}


//MARK:- Filter
extension SellerProfileVC: FilterData{
    func filterProduct(rate: Int, color: [String], priceFrom: Double, priceTo: Double) {
        let lat = UDHelper.UserCoordinates.lat
        let long = UDHelper.UserCoordinates.long
        
        filterData(colorsID: color, overall_rate: rate, lat: lat, lng: long, priceFrom: priceFrom, priceTo: priceTo, selling: 0)
    }
    
    
}
