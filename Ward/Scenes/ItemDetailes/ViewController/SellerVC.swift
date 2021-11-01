//
//  SellerVC.swift
//  Ward
//
//  Created by Shadi Elattar on 9/27/21.
//

import UIKit

class SellerVC: UIViewController {

    @IBOutlet weak var userImg_iv: UIImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var descripation: UILabel!
    @IBOutlet weak var rate: RatingView!
    
    var user: User?
    var storeID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        rate.ConfigurasWithRating(rating: 3)
        userImg_iv.getImage(imageUrl: user?.imagePath ?? "")
        username_lbl.text = user?.name ?? ""
    }
 
    @IBAction func viewProfileTapped(_ sender: Any) {
        print("viewProfileTapped")
        let sb = UIStoryboard(name: "SellerProfile", bundle: nil).instantiateViewController(withIdentifier: "SellerProfileVC") as! SellerProfileVC
        sb.user = user
        sb.storeID = storeID
        self.navigationController?.pushViewController(sb, animated: true)
    }
}
