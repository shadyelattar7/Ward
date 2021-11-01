//
//  CartDetailesVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/13/21.
//

import UIKit
import SVProgressHUD
import UITextView_Placeholder

class CartDetailesVC: UIViewController {

    @IBOutlet weak var userImg_iv: CircleImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardMessage_tv: UITextView!
    @IBOutlet weak var enterCoupon_tf: UITextField!
    @IBOutlet weak var subTotalPrice_tf: UILabel!
    @IBOutlet weak var subTotal_lbl: UILabel!
    @IBOutlet weak var deliveryFee_lbl: UILabel!
    @IBOutlet weak var totalAmount_lbl: UILabel!
    @IBOutlet weak var buy_btn: UIButton!
    
    var cart: Cart?
    var indexPathRow: Int = 0
    var user_address_exist: Bool = false
    var deliveryFee: Int = 0
    var address_complete: Bool = false
    
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
        print("StoreID: \(cart?.store_id ?? 0)")
        checkAddressAndGetFee(storeId: cart?.store_id ?? 0)
        tableViewConfigure()
    }
    
    private func setupView(){
        userImg_iv.getImage(imageUrl: cart?.store?.user?.imagePath ?? "")
        username_lbl.text =  cart?.store?.user?.name ?? ""
        cardMessage_tv.placeholder = "Write your Message"
        
        let items = cart?.cart_items?.count
        
        buy_btn.setTitle("Buy \(items ?? 0) items for \(cart?.total ?? 0) SR", for: .normal)
        subTotalPrice_tf.text = "\(cart?.total ?? 0) SR"
        subTotal_lbl.text = "Subtotal (\(cart?.cart_items?.count ?? 0) Items)"
        
    }
    
    
    private func paymentSummary(){
        let items = cart?.cart_items?.count
        buy_btn.setTitle("Buy \(items ?? 0) items for \(cart?.total ?? 0) SR", for: .normal)
        subTotalPrice_tf.text = "\(cart?.total ?? 0) SR"
        subTotal_lbl.text = "Subtotal (\(cart?.cart_items?.count ?? 0) Items)"
        totalAmount_lbl.text = "\(cart?.total ?? 0) SR"
    }
    
    private func tableViewConfigure(){
        //CartDetailesCell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNIB(cell: CartDetailesCell.self)
    }
    
    private func getCart(){
        APIManagerCart.getCart { result in
            if result.status == 200{
                print("Get cart successfully")
                self.cart = result.items?[self.indexPathRow]
                self.paymentSummary()
                
                
                self.tableView.reloadData()
            }else{
                print("Get cart failure")
            }
        }
    }
    
    private func updateQuantity(product_id: Int,cart_id: Int,store_id: Int,quantity: Int ){
        SVProgressHUD.show()
        ApiManagerUpdateQty.updateQuantity(product_id: product_id, cart_id: cart_id, store_id: store_id, quantity: quantity) { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Update quantity Successfully")
                self.getCart()
            }else{
                print("Messages: \(result.message ?? "")")
                print("Error: \(result.errors ?? [])")
                print("Update quantity Failure")
            }
        }
    }

    private func checkAddressAndGetFee(storeId: Int){
        APIManagerCheckAddressFee.checkAddressFee(storeId: storeId) { result in
            if result.status == 200{
                print("StoreID: \(storeId)")
                print("check Address And GetFee Successfully")
                self.deliveryFee_lbl.text = "\(result.data?.delivery_fee ?? 0)"
                self.deliveryFee = result.data?.delivery_fee ?? 0
                self.user_address_exist = result.data?.user_address_exist ?? false
                self.address_complete = result.data?.address_complete ?? false
                UDHelper.UserAddressExist = result.data?.user_address_exist ?? false
                self.totalAmount_lbl.text = "\((self.cart?.total ?? 0) + (result.data?.delivery_fee ?? 0)) SR"
            }else{
                print("check Address And GetFee Failure")
            }
        }
    }
    
    private func deleteCartItem(cart_item_id: Int){
        SVProgressHUD.show()
        ApiManagerDeleteCartItem.deleteCartItem(cart_item_id: cart_item_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("delete cart item successfully")
                ToastManager.shared.showToast(message: "Delete cart item successfully", view: self.view, postion: .top, backgroundColor: .systemGreen)
                self.getCart()
            }else{
                print("Message: \(result.message ?? "")")
                print("Errors: \(result.errors ?? [])")
                print("delete cart item failure")
            }
        }
    }
    
    @IBAction func applyCouponTapped(_ sender: Any) {
        print("Apply Coupon")
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buyTapped(_ sender: Any) {
       // CartDetailesSecStepVC
        
        let sb = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartDetailesSecStepVC") as! CartDetailesSecStepVC
        sb.cart = self.cart
        sb.delivery_fee = self.deliveryFee
        sb.user_address_exist = self.user_address_exist
        sb.address_complete = self.address_complete
        sb.note = self.cardMessage_tv.text!
    
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
}


extension CartDetailesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart?.cart_items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailesCell", for: indexPath) as! CartDetailesCell
        let product = cart?.cart_items?[indexPath.row]
        
        cell.productName_lbl.text = product?.product?.name ?? ""
        cell.productIm_iv.getImage(imageUrl: product?.product?.imagePath ?? "")
        cell.productPrice_lbl.text = "\(product?.product?.price ?? 0) SR"
        cell.colorName_lbl.text = product?.product?.colors?.first?.name ?? ""
        cell.size_lbl.text = product?.product?.sizes?.first?.name_en ?? ""
        cell.selected_lbl.text = "\(product?.quantity ?? 0)"
        cell.allBtnsSetupView(tag: product?.quantity ?? 0)
        cell.selectedQuantityTapped = { [weak self] quantity in
            guard let self = self else {return}
            print("Quantity: \(quantity)")
            print("Store ID: \(self.cart?.store_id ?? 0)")
            print("Cart ID: \(product?.cart_id ?? 0)")
            print("Product ID: \(product?.product_id ?? 0)")
            self.updateQuantity(product_id: product?.product_id ?? 0, cart_id: product?.cart_id ?? 0, store_id: self.cart?.store_id ?? 0, quantity: quantity)
        }
    
        cell.removeTapped = { [weak self] in
            guard let self = self else {return}
            self.deleteCartItem(cart_item_id: product?.id ?? 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
}
