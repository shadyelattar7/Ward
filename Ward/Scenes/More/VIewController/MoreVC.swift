//
//  MoreVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/18/21.
//

import UIKit

class MoreVC: UIViewController {

    @IBOutlet weak var userImg_iv: CircleImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var userEmail_lbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var tableSideData = [
        (name: "Shipping address",id:1, icon: #imageLiteral(resourceName: "Iconly-Light-Location-1")),
        (name: "Wallet",id:2, icon: #imageLiteral(resourceName: "Iconly-Light-Wallet")),
        (name: "Orders",id:3, icon: #imageLiteral(resourceName: "Iconly-Light-Document")),
        (name: "Message",id:4, icon: #imageLiteral(resourceName: "Iconly-Light-Message")),
        (name: "Wishlist",id:5, icon: #imageLiteral(resourceName: "Iconly-Light-Heart")),
        (name: "Language",id:6, icon: #imageLiteral(resourceName: "Iconly-Light-Activity")),
        (name: "Privacy policy",id:7, icon: #imageLiteral(resourceName: "Iconly-Light-Lock")),
        (name: "About us",id:8, icon: #imageLiteral(resourceName: "Iconly-Light-Info Circle")),
        (name: "Logout",id:9, icon: #imageLiteral(resourceName: "Component 616 – 1-1"))
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUserData()
        tableViewConfiguration()
    }
    
    private func setupView(){
        parent?.tabBarItem.image = #imageLiteral(resourceName: "unselectedGroup 53891")
        parent?.tabBarItem.selectedImage = #imageLiteral(resourceName: "Group 53891").withRenderingMode(.alwaysOriginal)
    }
    
    private func setUserData(){
        let userImg = UDHelper.imagePath
        userImg_iv.getImage(imageUrl: userImg)
        let username = UDHelper.name
        username_lbl.text = username
        let userEmail = UDHelper.mail
        userEmail_lbl.text = userEmail
    }
  
    private func tableViewConfiguration(){
        //MoreCell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNIB(cell: MoreCell.self)
        tableView.separatorStyle = .none
    }
    
    @IBAction func goToProfileTapped(_ sender: Any) {
        print("1234")
        let sb = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
}

//MARK:- UITableView Configuration
extension MoreVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSideData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell
        
        
        cell.moreIcon_iv.image = tableSideData[indexPath.row].icon
        
        
        if tableSideData[indexPath.row].id == 9{
            if UDHelper.token == "" {
              
                cell.itemName_lbl.text = "Login"
            }else{
                print("nice you authorized")
                cell.itemName_lbl.text = "Logout"
            }
        }else{
            cell.itemName_lbl.text = tableSideData[indexPath.row].name
        }
        
        if tableSideData[indexPath.row].id == 4 {
            cell.chatCounterView.isHidden = false
        }else{
            cell.chatCounterView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = tableSideData[indexPath.row].id
        switch id{
        case 1:
            if UDHelper.token == "" {
                QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
            }else{
                print("nice you authorized")
                let sb = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressesVC") as! AddressesVC
                self.navigationController?.pushViewController(sb, animated: true)
            }
            print("shipping address")
        case 2:
            print("Wallet")
        case 3:
            print("orders")
            if UDHelper.token == "" {
                QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
            }else{
                print("nice you authorized")
                let sb = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderVC") as! OrderVC
                self.navigationController?.pushViewController(sb, animated: true)
            }
        case 4:
            print("Message")
        case 5:
            print("Wishlist")
            if UDHelper.token == "" {
                QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
            }else{
                print("nice you authorized")
                let sb = UIStoryboard(name: "Wishlist", bundle: nil).instantiateViewController(withIdentifier: "WishlistVC") as! WishlistVC
                self.navigationController?.pushViewController(sb, animated: true)
            }
        case 6:
            print("language")
        case 7:
            print("privacy policy")
        case 8:
            print("about us")
        case 9:
            if UDHelper.token == "" {
                let signinVC = UIStoryboard(name: "Auth", bundle: nil)
                    .instantiateViewController(withIdentifier: "AuthNav")
                self.present(signinVC, animated: true, completion: nil)
            }else{
                print("nice you authorized")
                UDHelper.resetKeysWithoutLogoutAPI()
            }
            print("Logout")
        default:
            print("ERROR N/A")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
