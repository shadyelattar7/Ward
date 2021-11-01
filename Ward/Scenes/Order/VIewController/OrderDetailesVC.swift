//
//  OrderDetailesVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/19/21.
//

import UIKit
import SVProgressHUD

class OrderDetailesVC: UIViewController {

    @IBOutlet weak var userImage_iv: CircleImageView!
    @IBOutlet weak var username_lbl: UILabel!
    
    
    @IBOutlet weak var cancelOrder_btn: UIButton!
    @IBOutlet weak var goToPayment_btn: UIButton!
    
    @IBOutlet weak var shipment_lbl: UILabel!
    @IBOutlet weak var orderDate_lbl: UILabel!
    @IBOutlet weak var periodOfDelivery_lbl: UILabel!
    
    
    @IBOutlet weak var countryname_lbl: UILabel!
    @IBOutlet weak var cityName_lbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var subtotalText_lbl: UILabel!
    @IBOutlet weak var subTotal_lbl: UILabel!
    @IBOutlet weak var walletText_lbl: UILabel!
    @IBOutlet weak var wallet_lbl: UILabel!
    @IBOutlet weak var discountText_lbl: UILabel!
    @IBOutlet weak var discount_lbl: UILabel!
    @IBOutlet weak var deliveryFee_lbl: UILabel!
    @IBOutlet weak var totalAmount_lbl: UILabel!
    
    @IBOutlet weak var progress1_iv: UIImageView!
    @IBOutlet weak var progress2_iv: UIImageView!
    @IBOutlet weak var progress3_iv: UIImageView!
    @IBOutlet weak var progress4_iv: UIImageView!
    @IBOutlet weak var progress5_iv: UIImageView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    
    var orders: OrdersData?
    var deliveryFee: Double = 0
    
    let garyColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
    let greenColor = UIColor(red: 78/255, green: 167/255, blue: 41/255, alpha: 1)
    
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
        showData()
        tableViewConfiguration()
    }
    
    private func setupView(){
     
    }
    
    private func showData(){
        userImage_iv.getImage(imageUrl: orders?.store?.imagePath ?? "")
        username_lbl.text = orders?.store?.name ?? ""
        shipment_lbl.text = "\(orders?.id ?? 0)"
        let date = DateFormat.dateFormat(dateEx: orders?.created_at ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.sZ")
        orderDate_lbl.text = date
        periodOfDelivery_lbl.text = orders?.delivery_time ?? ""
        countryname_lbl.text = orders?.address?.area ?? ""
        cityName_lbl.text = orders?.address?.building_name_number
        subTotal_lbl.text = "\((orders?.total_price ?? 0)) SR"
        subtotalText_lbl.text = "Subtotal (\(orders?.order_items?.count ?? 0) Items)"
       
        progress(progressNo: orders?.status_id ?? 0)
        
        cancelOrder_btn.isHidden = true
        goToPayment_btn.isHidden = true
        
        switch orders?.status_id ?? 0{
        case 0:
            cancelOrder_btn.isHidden = false
        case 1:
            goToPayment_btn.isHidden = false
        default:
            print("ERROR")
        }
    }
    
    
    private func tableViewConfiguration(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNIB(cell: OrderItemTableCell.self)
    }
    
    func progress (progressNo: Int){
       switch progressNo {
       case 0: // wating
           view1.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           self.progress1_iv.image = #imageLiteral(resourceName: "progress")
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.progress2_iv.image = #imageLiteral(resourceName: "unProgress")
           }
           self.progress3_iv.image = #imageLiteral(resourceName: "unProgress")
           self.progress4_iv.image = #imageLiteral(resourceName: "unProgress")
           self.progress5_iv.image = #imageLiteral(resourceName: "unProgress")
     
       case 1://payment
           view1.animate(mainColor: greenColor, subColor: garyColor, duration: 0)
           view2.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           progress1_iv.image = #imageLiteral(resourceName: "progress")
           progress2_iv.image = #imageLiteral(resourceName: "progress")
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.progress3_iv.image = #imageLiteral(resourceName: "unProgress")
           }
           self.progress4_iv.image = #imageLiteral(resourceName: "unProgress")
           self.progress5_iv.image = #imageLiteral(resourceName: "unProgress")
     
       case 2://preparing
           view1.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           view2.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           view3.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           progress1_iv.image = #imageLiteral(resourceName: "progress")
           progress2_iv.image = #imageLiteral(resourceName: "progress")
           progress3_iv.image = #imageLiteral(resourceName: "progress")
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.progress4_iv.image = #imageLiteral(resourceName: "unProgress")
           }
           self.progress5_iv.image = #imageLiteral(resourceName: "unProgress")
    
       case 3: //on way
           view1.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           view2.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           view3.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           view4.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           progress1_iv.image = #imageLiteral(resourceName: "progress")
           progress2_iv.image = #imageLiteral(resourceName: "progress")
           progress3_iv.image = #imageLiteral(resourceName: "progress")
           progress4_iv.image = #imageLiteral(resourceName: "progress")
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.progress5_iv.image = #imageLiteral(resourceName: "unProgress")
           }
      
       case 4: //done
           view1.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           view2.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           view3.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           view4.animate(mainColor: greenColor, subColor: garyColor, duration: 1)
           progress1_iv.image = #imageLiteral(resourceName: "progress")
           progress2_iv.image = #imageLiteral(resourceName: "progress")
           progress3_iv.image = #imageLiteral(resourceName: "progress")
           progress4_iv.image = #imageLiteral(resourceName: "progress")
           progress5_iv.image = #imageLiteral(resourceName: "progress")
       default:
           print("Error N/A")
       }
   }
   
    private func cancelOrder(order_id: Int){
        SVProgressHUD.show()
        ApiManagerCancelOrder.cancelOrder(order_id: order_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("Cancel order successfully")
                ToastManager.shared.showToast(message: "Cancel order successfully", view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let window = UIApplication.shared.keyWindow else {return}
                    let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar")
                    window.rootViewController = productVC
                }
                
            }else{
                print("Cancel order failure")
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
       // cancelOrder(order_id: orders?.id ?? 0)
        
        let rate = RateVC()
        rate.modalPresentationStyle = .overFullScreen
        self.present(rate, animated: true, completion: nil)
    }
    
    @IBAction func goToPaymentTapped(_ sender: Any) {
        print("Go to payment")
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- UITableView Configruation
extension OrderDetailesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.order_items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableCell", for: indexPath) as! OrderItemTableCell
        
        let product = orders?.order_items?[indexPath.row].product
        
        self.deliveryFee = product?.store?.delivery_fee ?? 0.0
        deliveryFee_lbl.text = "\(deliveryFee) SR"
        totalAmount_lbl.text = "\((orders?.total_price ?? 0) + Int(deliveryFee)) SR"
        
        cell.item_iv.getImage(imageUrl: product?.imagePath ?? "")
        cell.itemname_lbl.text = product?.name ?? ""
        cell.quantity_lbl.text = "Quantity : \(orders?.order_items?[indexPath.row].quantity ?? 0)"
        cell.descripation_lbl.text = product?.description_en ?? ""
        cell.itemPrice_lbl.text = "\(product?.price ?? 0) SR"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
