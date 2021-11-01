//
//  CartDetailesSecStepVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/17/21.
//

import UIKit
import BEMCheckBox
import SVProgressHUD

class CartDetailesSecStepVC: UIViewController, BEMCheckBoxDelegate {

    @IBOutlet weak var addressname_lbl: UILabel!
    @IBOutlet weak var toSomeOne: BEMCheckBox!
    @IBOutlet weak var toMe: BEMCheckBox!
    @IBOutlet weak var recipientname_lbl: UITextField!
    @IBOutlet weak var RecipientDetails: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var OrderDetailsTabelView: UITableView!
  
    @IBOutlet weak var subTotal_lbl: UILabel!
    @IBOutlet weak var totalAmount_lbl: UILabel!
    @IBOutlet weak var fee_lbl: UILabel!
    @IBOutlet weak var subtotalText_lbl: UILabel!
    @IBOutlet weak var dateTF: UITextField!
    
    var cart: Cart?
    var storeID: Int = 0
    var note: String = ""
    var PeriodOfDelivery: [String] = [
        "8:00 am - 12:00 pm",
        "13:00 pm - 17:00 pm",
        "18:00 pm - 23:59 pm"
    ]
    var indexPathArr: Int = 0
    var SelectedperiodOfDelivery: String = "8:00 am - 12:00 pm"

    let datePicker = UIDatePicker()
    var date: String = ""
    
    var user_address_exist: Bool = false
    var address_complete: Bool = false
    var delivery_fee: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        
        checkAddressAndGetFee(storeId: cart?.store_id ?? 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        createDatePickerView()
    }
    
    private func setupView(){
        toSomeOne.delegate = self
        toMe.delegate = self
        RecipientDetails.isHidden = false
        toSomeOne.setOn(true, animated: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        OrderDetailsTabelView.delegate = self
        OrderDetailsTabelView.dataSource = self
        
        let address = UDHelper.address
        addressname_lbl.text = address
        subtotalText_lbl.text = "\(cart?.total ?? 0) SR"
        subTotal_lbl.text = "Subtotal (\(cart?.cart_items?.count ?? 0) Items)"
        totalAmount_lbl.text = "\(cart?.total ?? 0) SR"
        fee_lbl.text = "\(delivery_fee) SR"
        dateTF.addTarget(self, action: #selector(handlePressDate), for: .touchDown)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.tag == 0 {
            toSomeOne.setOn(true, animated: true)
            toMe.setOn(false, animated: true)
            RecipientDetails.isHidden = false
        }else if checkBox.tag == 1 {
            toMe.setOn(true, animated: true)
            toSomeOne.setOn(false, animated: true)
            RecipientDetails.isHidden = true
        }
    }
    
    @objc func handlePressDate(textField: UITextField) {
        print("handlePressDate")
        createDatePickerView()
    }
    
    private func createDatePickerView(){
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedDate))
        toolbar.setItems([doneBtn], animated: false)
        dateTF.inputAccessoryView = toolbar
        dateTF.inputView = datePicker
        
    }
    
    @objc func donePressedDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: datePicker.date)
        dateTF.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    private func checkAddressAndGetFee(storeId: Int){
        APIManagerCheckAddressFee.checkAddressFee(storeId: storeId) { result in
            if result.status == 200{
                print("StoreID: \(storeId)")
                print("check Address And GetFee Successfully")
              print("Data: \(result.data)")
                self.user_address_exist = result.data?.user_address_exist ?? false
                self.address_complete = result.data?.address_complete ?? false
                UDHelper.UserAddressExist = result.data?.user_address_exist ?? false
                self.totalAmount_lbl.text = "\((self.cart?.total ?? 0) + (result.data?.delivery_fee ?? 0)) SR"
            }else{
                print("check Address And GetFee Failure")
            }
        }
    }
    
    
    private func placeOrder(){
        SVProgressHUD.show()
        
        var receiver: String = UDHelper.name
        if recipientname_lbl.text != ""{
            receiver = recipientname_lbl.text!
        }else{
            receiver = UDHelper.name
        }
        
        print("Receiver: \(receiver)")
        print("Username: \(UDHelper.name)")
        
        APIManagerCreateOrder.createOrder(store_id: "\(cart?.store_id ?? 0)", address_id: "\(UDHelper.addressID)", payment_method: "cash", delivery_date: dateTF.text!, delivery_time: SelectedperiodOfDelivery, sender: UDHelper.name, receiver: receiver, note: note) { result in
            SVProgressHUD.dismiss()
            if result.status == 201{
                print("create order successfully")
                ToastManager.shared.showToast(message: "create order successfully", view: self.view, postion: .top, backgroundColor: .systemGreen)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let window = UIApplication.shared.keyWindow else {return}
                    let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar")
                    window.rootViewController = sb
                }
            }else{
                print("Message: \(result.messages ?? [])")
                print("Errors: \(result.errors ?? [])")
                print("Message: \(result.message ?? "")")
                print("create order failure")
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func placeOrderTapped(_ sender: Any) {
        if  address_complete{
            print("Check out ya m3lm")
            print("Address ID: \(UDHelper.addressID)")
            guard let date = dateTF.text, !date.isEmpty else {
                ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
                return
            }
            placeOrder()
        }else{
            let sb = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "NewAddressVC") as! NewAddressVC
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
    
}

//PeriodOfDeliveryCell
extension CartDetailesSecStepVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return cart?.cart_items?.count ?? 0
        }else{
            return PeriodOfDelivery.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailesSecStep", for: indexPath) as! OrderDetailesSecStep
            
            let product = cart?.cart_items?[indexPath.row]
            cell.itemName_lbl.text = product?.product?.name ?? ""
            cell.itemPrice_lbl.text = "\(product?.product?.price ?? 0) SR"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeriodOfDeliveryCell", for: indexPath) as! PeriodOfDeliveryCell
            
            cell.time_lbl.text = PeriodOfDelivery[indexPath.row]
            
            if indexPathArr == (indexPath.row){
                cell.checkImg_iv.image = #imageLiteral(resourceName: "Component 622 – 1")
            }else{
                cell.checkImg_iv.image = #imageLiteral(resourceName: "Ellipse 1131")
            }
            
            return cell
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == OrderDetailsTabelView{
            if indexPathArr == (indexPath.row){
                indexPathArr = 0
                let id = PeriodOfDelivery[indexPath.row]
                SelectedperiodOfDelivery = "\(id)"
            }else{
                indexPathArr = indexPath.row
                let id = PeriodOfDelivery[indexPath.row]
                SelectedperiodOfDelivery = "\(id)"
            }
            OrderDetailsTabelView.reloadData()
        }
    }
}
