//
//  HomeVC.swift
//  Ward
//
//  Created by Shadi Elattar on 9/22/21.
//

import UIKit
import SVProgressHUD

let dismissNotfiactionKey = "dismissView"

class HomeVC: UIViewController {
    
    @IBOutlet weak var counterCart_lbl: UILabel!
    @IBOutlet weak var cartIcon_img: UIImageView!
    @IBOutlet weak var addressTitle_lbl: UILabel!
    @IBOutlet weak var slideerImgCollV: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    var sliderImg: [UIImage] = [
        UIImage(named: "Component 614 – 1")!,
        UIImage(named: "Component 614 – 1")!,
        UIImage(named: "Component 614 – 1")!,
        UIImage(named: "Component 614 – 1")!
    ]
    
    
    var bestseller: [Bestseller] = []
    var categories: [Categories] = []
    
    
    var currentIndex = 0
    var timer: Timer?
    let dismissView = Notification.Name(dismissNotfiactionKey)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print("1234")
        if UDHelper.UserCoordinates.lat == 0.0 {
            print("Location not access")
            let sb = UIStoryboard(name: "GetLocation", bundle: nil).instantiateInitialViewController()
            sb?.modalPresentationStyle = .overFullScreen
            self.present(sb!, animated: true, completion: nil)
        }else{
            print("Location access")
            let address = UDHelper.address
            addressTitle_lbl.text = address
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTimer()
        createObserver()
        tableViewConfiguration()
        collectionViewConfiguration()
        
        let lat = UDHelper.UserCoordinates.lat
        let long = UDHelper.UserCoordinates.long
        
        getHomeData(lat: lat, long: long)
    }
    
    
    private func setupView(){
        parent?.tabBarItem.image = #imageLiteral(resourceName: "unselectedHome")
        parent?.tabBarItem.selectedImage = #imageLiteral(resourceName: "selectedHome").withRenderingMode(.alwaysOriginal)
        
        print("Token: \(UDHelper.token)")
        
    }
    
    
    
    private func tableViewConfiguration(){
        
        //        BestsellingTableView.delegate = self
        //        BestsellingTableView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func collectionViewConfiguration(){
        slideerImgCollV.delegate = self
        slideerImgCollV.dataSource = self
    }
    
    func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval:  3.0 , target: self, selector: #selector(handleTimerSliderImage), userInfo: nil, repeats: true)
    }
    
    @objc func handleTimerSliderImage(){
        let desiredScrollPostion = (currentIndex < sliderImg.count - 1) ? currentIndex + 1 : 0
        slideerImgCollV.scrollToItem(at: IndexPath(row: desiredScrollPostion, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    

    
    private func getHomeData(lat: Double, long: Double){
        SVProgressHUD.show()
        APIManagerHomeData.getHomeData(lat: lat, long: long) { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Successfully get home data")
                self.bestseller = result.data ?? []
                self.categories = result.categories ?? []
                let overObj = Categories(id: 0, name_en: "", name_ar: "", image: "", name: "", imagePath: "", sub_categories: nil)
                self.categories.insert(overObj, at: 0)
                
                self.tableView.reloadData()
            }else{
                print("Failure get home data")
            }
        }
    }
    
    func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateLoaction), name: dismissView, object: nil)
    }
    
    @objc func updateLoaction(){
        print("123 dismissView")
        let address = UDHelper.address
        addressTitle_lbl.text = address
    }
    
    private func addToCart(product_id: Int,store_id: Int){
        SVProgressHUD.show()
        APIManagerAddToCart.addToCart(product_id: product_id, store_id: store_id, quantity: 1, sizeId: 1, cart_color_ids: [1])  { result in
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
                ToastManager.shared.showToast(message: "The add to wishlist was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
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
    
    
    @IBAction func openCartTapped(_ sender: Any) {
        print("OpenCartTapped")
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: UDKeys.token)
    }
    
    @IBAction func changeAddressTapped(_ sender: Any) {
        print("Change Location")
        
        let sb = UIStoryboard(name: "GetLocation", bundle: nil).instantiateInitialViewController()
        self.present(sb!, animated: true, completion: nil)
        //        let sb = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "AddAddressMapVC") as! AddAddressMapVC
        //        self.navigationController?.pushViewController(sb, animated: true)
    }
}


//MARK:- Slider Data Source
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: SliderCell.self, for: indexPath)
        cell.sliderImage_iv.image = sliderImg[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.slideerImgCollV{
            currentIndex = Int(scrollView.contentOffset.x / slideerImgCollV.frame.size.width)
            pageController.currentPage = currentIndex
            
        }
    }
}


//MARK:- UITableViewController Configuration
extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        //   let category = categories[indexPath.row - 1]
        
        cell.indexpathRow = indexPath.row
        cell.subCategory = categories[indexPath.row].sub_categories
        cell.product = bestseller
        
        //       let title = "lang".localized == "en" ? category.name_en : category.name_ar
        
        var isBestselling: Bool = false
        
        if indexPath.row == 0 {
            cell.categoryTitle_lbl.text = "Bestselling"
            isBestselling = true
        }else{
            cell.categoryTitle_lbl.text = categories[indexPath.row].name_en
            isBestselling = false
        }
        
        cell.addToFavo = { [weak self] productID, status in
            guard let self = self else {return}
            print("Status UIButton: \(status)")
            if UDHelper.token == "" {
                QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
            }else{
                print("nice you authorized")
                
                let inWishList = self.bestseller[indexPath.row].in_wishlist ?? 0
                
                if inWishList == 0{
                    if status == true{
                        print("Add To WishList")
                        self.addToWishlist(product_id: productID)
                    }else{
                        print("delete from WishList")
                        self.removeFromWishlist(product_id: productID)
                    }
                }else{
                    if status == true{
                        print("delete from WishList")
                        self.removeFromWishlist(product_id: productID)
                    }else{
                        print("Add To WishList")
                        self.addToWishlist(product_id: productID)
                    }
                }
                
            }
        }
        
        cell.addToCart = { [weak self] productID, storeID in
            guard let self = self else {return}
            print("Product ID: \(productID), Store ID: \(storeID)")
            if UDHelper.token == "" {
                QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
            }else{
                print("nice you authorized")
                self.addToCart(product_id: productID, store_id: storeID)
            }
        }
        
        cell.onCellTapped = { [weak self] product in
            guard let self = self else {return}
            //   print("Product: \(product)")
            let sb = UIStoryboard(name: "ItemDetailes", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailesVC") as! ItemDetailesVC
            sb.product = product
            self.navigationController?.pushViewController(sb, animated: true)
            
        }
        
        cell.seeMore = { [weak self] in
            guard let self = self else {return}
            print("See more 123 \(indexPath.row)")
            let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SeeMoreVC") as! SeeMoreVC
            sb.isBestselling = isBestselling
            sb.categoryID = self.categories[indexPath.row].id ?? 0
            sb.subCategoryName = self.categories[indexPath.row].name_en ?? ""
            self.navigationController?.pushViewController(sb, animated: true)
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

