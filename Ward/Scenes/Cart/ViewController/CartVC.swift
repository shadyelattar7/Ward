//
//  CartVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/13/21.
//

import UIKit
import SVProgressHUD

class CartVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cart: [Cart] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        if UDHelper.token == "" {
            QuickAlert.showWith(message: "You have to log in to use this feature.", in: self)
        }else{
            print("nice you authorized")
            getCart()
        }
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        tableViewConfiguration()
      //  getCart()
    }
    
    private func setupView(){
        parent?.tabBarItem.image = #imageLiteral(resourceName: "Iconly-Light-Buy")
        parent?.tabBarItem.selectedImage = #imageLiteral(resourceName: "Iconly-Bold-Buy").withRenderingMode(.alwaysOriginal)
    }

    
    private func tableViewConfiguration(){
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    private func getCart(){
        SVProgressHUD.show()
        APIManagerCart.getCart { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("Get cart successfully")
                self.cart = result.items ?? []
                self.tableView.reloadData()
            }else{
                print("Get cart failure")
            }
        }
    }
    
}

//MARK: - Table View Configuration
extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CartTabelCell", for: indexPath) as! CartTabelCell
        let store = cart[indexPath.row]
        cell.product = store.cart_items
        
        
        cell.userImg_iv.getImage(imageUrl: store.store?.user?.imagePath ?? "")
        cell.username_lbl.text = store.store?.user?.name ?? ""
        cell.checkoutTapped = { [weak self] in
            guard let self = self else {return}
            print("Checkout \(store.id ?? 0)")
            let sb = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartDetailesVC") as! CartDetailesVC
            sb.cart = store
            sb.indexPathRow = indexPath.row
            self.navigationController?.pushViewController(sb, animated: true)
        }
        
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
//            let productID = item[indexPath.row].id ?? 0
//             print("Delete: \(productID)")
//            deleteItem(productID: productID)
        }
    }
}
