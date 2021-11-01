//
//  ItemDetailesVC.swift
//  Ward
//
//  Created by Shadi Elattar on 9/27/21.
//

import UIKit
import SVProgressHUD

class ItemDetailesVC: UIViewController {

    @IBOutlet weak var titleVC_lbl: UILabel!
    @IBOutlet weak var slideerImgCollV: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var itemName_lbl: UILabel!
    @IBOutlet weak var itemPrice_lbl: UILabel!
    @IBOutlet weak var itemDescripation_lbl: UILabel!
    @IBOutlet weak var ChoeesViewCollV: UICollectionView!
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var recommendationCollV: UICollectionView!
    

    var currentIndex = 0
    var timer: Timer?
    var product: Bestseller?
    var imageSlider: [Images] = []
    var recommendationProducts: [Bestseller] = []
    
    var chooseeView: [String] = [
        "Product Details",
        "Seller"
    ]
    
    var colorID: [Int] = []
    var sizeID: Int = 0
    
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
        setupTimer()
        showData()
        fetchRecommendationProducts()
    }
    private func setupView(){
        secondView.isHidden = true
    }
    
    private func collectionViewConfiguration(){
        slideerImgCollV.delegate = self
        slideerImgCollV.dataSource = self
        
        ChoeesViewCollV.delegate = self
        ChoeesViewCollV.dataSource = self
        ChoeesViewCollV.registerNIB(ChoessCell.self)
        ChoeesViewCollV.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        
        recommendationCollV.delegate = self
        recommendationCollV.dataSource = self
        recommendationCollV.registerNIB(ItemCell.self)
    }
    

    func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval:  3.0 , target: self, selector: #selector(handleTimerSliderImage), userInfo: nil, repeats: true)
    }
    
    @objc func handleTimerSliderImage(){
        let desiredScrollPostion = (currentIndex < imageSlider.count - 1) ? currentIndex + 1 : 0
        slideerImgCollV.scrollToItem(at: IndexPath(row: desiredScrollPostion, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    private func showData(){

        self.imageSlider = product?.images ?? []
        self.pageController.numberOfPages = imageSlider.count
        self.slideerImgCollV.reloadData()
        
        titleVC_lbl.text = product?.name_en ?? ""
        itemName_lbl.text = product?.name_en ?? ""
        let price = product?.price ?? 0.0
        itemPrice_lbl.text = "\(price.rounded(toPlaces: 3))"
        itemDescripation_lbl.text = product?.description_en ?? ""
      
        
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetailsVC"{
            let destVC = segue.destination as! ProductDetailsVC
            
            destVC.colors = self.product?.colors ?? []
            destVC.typeOfSize = self.product?.sizes ?? []
            destVC.selectColorTap = {  [weak self] id in
                guard let self = self else {return}
                self.colorID = id
                print("FUCK YOU Color _|_ \(id)")
            }
            
    
            destVC.selectSizeTap = { [weak self] id in
                guard let self = self else {return}
                self.sizeID = id
                print("FUCK YOU  Size _|_ \(id)")
            }
        }else if segue.identifier == "SellerVC"{
            let secondVC = segue.destination as! SellerVC
            secondVC.user = self.product?.store?.user
            secondVC.storeID = self.product?.store_id ?? 0
            
        }
    }
    
    
    private func fetchRecommendationProducts(){
        SVProgressHUD.show()
        let storeID = product?.store_id ?? 0
        APIManagerRecommendationProductsManager.getRecommendationProducts(store_id: "\(storeID)") { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Successfully fetch recommendation product")
                self.recommendationProducts = result.data?.products ?? []
                self.recommendationCollV.reloadData()
            }else{
                print("Failure fetch recommendation product")
            }
        }
    }
    
    private func addToCart(product_id: Int,store_id: Int,sizeId: Int, cart_color_ids: [Int]){
        SVProgressHUD.show()
        APIManagerAddToCart.addToCart(product_id: product_id, store_id: store_id, quantity: 1, sizeId: sizeId, cart_color_ids: cart_color_ids)  { result in
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
    
    @IBAction func addToCartTapped(_ sender: Any) {
        if UDHelper.token == "" {
            QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
        }else{
            print("nice you authorized")
            self.addToCart(product_id: product?.id ?? 0, store_id: product?.store_id ?? 0, sizeId: self.sizeID, cart_color_ids: colorID)
        }
       
    }
    
}


//MARK:- Slider Data Source
extension ItemDetailesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == slideerImgCollV{
            return imageSlider.count
        }else if collectionView == ChoeesViewCollV {
            return chooseeView.count
        }else{
            return recommendationProducts.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == slideerImgCollV{
            let cell = collectionView.dequeue(cell: SliderCell.self, for: indexPath)
            cell.sliderImage_iv.getImage(imageUrl: imageSlider[indexPath.row].imagePath ?? "")
            return cell
        }else if collectionView == ChoeesViewCollV{
            let cell = collectionView.dequeue(cell: ChoessCell.self, for: indexPath)
            cell.title_lbl.text = chooseeView[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeue(cell: ItemCell.self, for: indexPath)
            
            let bestseller = recommendationProducts[indexPath.row]
            
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
            
            cell.addToCart = { [weak self] in
                guard let self = self else {return}
                print("addToCartTapped")
                if UDHelper.token == "" {
                    QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
                }else{
                    print("nice you authorized")
                    self.addToCart(product_id: bestseller.id ?? 0, store_id: bestseller.store_id ?? 0, sizeId: 1, cart_color_ids: [1])
                }
                
            }
            cell.favorite = { [weak self] (status) in
                guard let self = self else {return}
                print("favoriteTapped")
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
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == slideerImgCollV{
            return collectionView.bounds.size
        }else if collectionView == ChoeesViewCollV{
            return CGSize(width: collectionView.frame.width / 2 , height: collectionView.frame.height)
        }else{
            return CGSize(width: collectionView.frame.width / 2 , height: collectionView.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ChoeesViewCollV{
            if indexPath.row == 0 {
                self.FirstView.isHidden = false
                self.secondView.isHidden = true
            }else{
                self.FirstView.isHidden = true
                self.secondView.isHidden = false
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.slideerImgCollV{
            currentIndex = Int(scrollView.contentOffset.x / slideerImgCollV.frame.size.width)
            pageController.currentPage = currentIndex
            
        }
    }
}
