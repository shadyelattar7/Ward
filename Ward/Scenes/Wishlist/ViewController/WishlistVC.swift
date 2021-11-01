//
//  WishlistVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/20/21.
//

import UIKit
import SVProgressHUD

class WishlistVC: UIViewController {
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var type: [String] = [
        "Favorite products",
        "Favorite sellers"
    ]
    
    var wishlist: [BaseWishlistData] = []
    var wishlistSeller: [BaseWishlistSellerData] = []
    
    var indexpathRow: Int = 0
    
    
    
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
        getWishlistProduct()
        collectioViewConfiguration()
        
    }
    
    private func setupView(){
        
    }
    
    private func collectioViewConfiguration(){
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.registerNIB(TypeCell.self)
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.registerNIB(StoreCell.self)
        productCollectionView.registerNIB(ItemCell.self)
        
    }
    
    private func getWishlistProduct(){
        SVProgressHUD.show()
        APIManagerGetWishist.getWishlist { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("get wishlist successfully")
                self.wishlist = result.data ?? []
                self.typeCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                self.productCollectionView.reloadData()
            }else{
                print("get wishlist failure")
            }
        }
    }
    
    private func getWishlistSeller(){
        SVProgressHUD.show()
        APIManagerGetWishist.getWishlistSeller { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("get wishlist successfully")
                self.wishlistSeller = result.data ?? []
                self.productCollectionView.reloadData()
            }else{
                print("get wishlist failure")
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
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- UICollectioView Configuration
extension WishlistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView{
            return type.count
        }else{
            if indexpathRow == 0{
                return wishlist.count
            }else{
                return wishlistSeller.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCollectionView{
            let cell = collectionView.dequeue(cell: TypeCell.self, for: indexPath)
            cell.title_lbl.text = type[indexPath.row]
            return cell
        }else{
            if indexpathRow == 0{
                let cell = collectionView.dequeue(cell: ItemCell.self, for: indexPath)
                let bestseller = wishlist[indexPath.row].product
                
                cell.itemImage_iv.getImage(imageUrl: bestseller?.imagePath ?? "")
                cell.itemName_lbl.text = bestseller?.name
                let price = bestseller?.price ?? 0
                cell.price_lbl.text = "\(price) SAR"
                let oldPrice = bestseller?.price_after_discount ?? 0.0
                
                cell.username_lbl.text = bestseller?.store?.user?.name ?? ""
                
                cell.favBtn.setImage(#imageLiteral(resourceName: "Component 616 – 1-2"), for: .normal)
                if bestseller?.price_after_discount == 0.0 {
                    cell.oldPrice_lbl.isHidden = true
                }else{
                    cell.oldPrice_lbl.isHidden = false
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(oldPrice.rounded(toPlaces: 3))" + "SAR")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.oldPrice_lbl.attributedText = attributeString
                    
                }
                
         
                cell.favorite = { [weak self] (status)in
                    guard let self = self else {return}
                    print("Add To Favorite ZZ")
                    if UDHelper.token == "" {
                        QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
                    }else{
                        print("nice you authorized")
                     
                    
                    }
                }
                
                cell.addToCart = { [weak self] in
                    guard let self = self else {return}
                    
                    if UDHelper.token == "" {
                        QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
                    }else{
                        print("nice you authorized")
                        self.addToCart(product_id: bestseller?.id ?? 0, store_id: bestseller?.store_id ?? 0)
                    }
                    
                }
                return cell

            }else{
                let cell = collectionView.dequeue(cell: StoreCell.self, for: indexPath)
                let store = wishlistSeller[indexPath.row].store
                cell.userImage_iv.getImage(imageUrl: store?.user?.imagePath ?? "")
              
                cell.username_lbl.text = store?.user?.name ?? ""
                return cell
            }
       
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView{
            indexpathRow = indexPath.row
            if indexPath.row == 0 {
                getWishlistProduct()
            }else{
                getWishlistSeller()
            }
        }else{
            print("Tapped on whishlist cell")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == typeCollectionView{
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }else{
            if indexpathRow == 0{
                return CGSize(width: (self.productCollectionView.frame.size.width - 20) / 2, height: 300)
            }else{
                return CGSize(width: (self.productCollectionView.frame.size.width - 20) / 2, height: 250)
            }
            
        }
        
    }
}
