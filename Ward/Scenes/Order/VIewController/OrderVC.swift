//
//  OrderVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/18/21.
//

import UIKit
import SVProgressHUD

class OrderVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var orders: [OrdersData] = []

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
        getOrder()
        tableViewCOnfiguration()
    }
    
    
    
    private func setupView(){
        
    }
    
    private func tableViewCOnfiguration(){
        //OrderCell
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func getOrder(){
        SVProgressHUD.show()
        APIManagerGetOrder.getOrder { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("get orders successfully")
                self.orders = result.orders?.data ?? []
                self.tableView.reloadData()
            }else{
                print("get orders failure")
            }
        }
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

//MARK:- UITableView Configuration
extension OrderVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order = orders[indexPath.row]
        
        
        cell.shipmentNo_lbl.text = "\(order.id ?? 0)"
        
        let orderDate = order.created_at ?? ""
        
        let date = DateFormat.dateFormat(dateEx: orderDate, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.sZ")
        cell.orderData_lbl.text = date
        
        cell.seller_lbl.text = order.store?.name ?? ""
        
        cell.progress(progressNo: order.status_id ?? 0)
        cell.product = order.order_items
        
        cell.statusID = order.status_id ?? 0
        
        cell.viewOrderDetailsTap = { [weak self] in
            guard let self = self else {return}
            print("View OrderDetails Tapped")
            let sb = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailesVC") as! OrderDetailesVC
            sb.orders = self.orders[indexPath.row]
            self.navigationController?.pushViewController(sb, animated: true)
             
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
