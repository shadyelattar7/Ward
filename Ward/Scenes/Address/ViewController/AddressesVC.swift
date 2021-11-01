//
//  AddressesVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/19/21.
//

import UIKit
import SVProgressHUD

class AddressesVC: UIViewController {
    
    @IBOutlet weak var addAddress_btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    

    
    var address: [Address] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        getAddresses()
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
       
    }
    
    private func setupView(){
        print("User Address: \(UDHelper.UserAddressExist)")
     
    }
    
    private func tableViewConfiguration(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNIB(cell: AddressCell.self)
    }
    
    private func getAddresses(){
        SVProgressHUD.show()
        APIManagerGetAddresses.getAddresses { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("get addresses successfully")
                self.address = result.addresses ?? []
                
                if !self.address.isEmpty {
                    self.tableView.isHidden = false
                    self.addAddress_btn.isHidden = false
                    self.tableView.reloadData()
                }else{
                    self.tableView.isHidden = true
                    self.addAddress_btn.isHidden = true
                }
                
            }else{
                //                print("Errors: \(result.errors ?? [])")
                //                print("Messages: \(result.messages ?? [])")
                //                print("Message: \(result.message ?? "")")
                print("get addresses failure")
            }
        }
    }
    
    private func setDefaultAddress(address_id: Int){
        SVProgressHUD.show()
        APIManagerSetDefualtAddress.setDefualtAddress(address_id: address_id) { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                ToastManager.shared.showToast(message: "The addres now is defualt.", view: self.view, postion: .top, backgroundColor: .systemGreen)
                self.getAddresses()
            }else{
                print("ERRORS: \(result.errors ?? [])")
                print("Messages: \(result.messages ?? [])")
                ToastManager.shared.showToast(message: result.message ?? "", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
    
    @IBAction func addShoppingAddressTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "AddAddressMapVC") as! AddAddressMapVC
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func addAddressTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "AddAddressMapVC") as! AddAddressMapVC
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- UITableView Configuration
extension AddressesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        
        cell.name_lbl.text = address[indexPath.row].name ?? ""
        cell.city_lbl.text = address[indexPath.row].area
        cell.address_lbl.text = address[indexPath.row].landmark ?? ""
        
        
        
        if address[indexPath.row].isDefault == 1{
            cell.check_iv.isHidden = false
        }else{
            cell.check_iv.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Address ID: \(address[indexPath.row].id ?? 0)")
        
    //    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        let lat = address[indexPath.row].address_lat ?? ""
        let long = address[indexPath.row].address_lat ?? ""
        UDHelper.UserCoordinates = (lat: Double(lat)!, long: Double(long)!)
        UDHelper.address = address[indexPath.row].name ?? ""
        
        setDefaultAddress(address_id: address[indexPath.row].id ?? 0)
    }
    
  

//     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//           tableView.cellForRow(at: indexPath)?.accessoryType = .none
//     }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
