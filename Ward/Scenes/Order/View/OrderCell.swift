//
//  OrderCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/18/21.
//

import UIKit

class OrderCell: UITableViewCell {
    
    
    @IBOutlet weak var shipmentNo_lbl: UILabel!
    @IBOutlet weak var orderData_lbl: UILabel!
    @IBOutlet weak var seller_lbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var progress1_iv: UIImageView!
    @IBOutlet weak var progress2_iv: UIImageView!
    @IBOutlet weak var progress3_iv: UIImageView!
    @IBOutlet weak var progress4_iv: UIImageView!
    @IBOutlet weak var progress5_iv: UIImageView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    
    var viewOrderDetailsTap: (()->())?
    var statusID: Int = 0
    
    var product: [Cart_items]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let garyColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
    let greenColor = UIColor(red: 78/255, green: 167/255, blue: 41/255, alpha: 1)
    
    var counter: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewConfiguration()
    }
    
    private func collectionViewConfiguration(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNIB(OrderItemCell.self)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func viewOrderDetailsTapped(_ sender: Any) {
//        progress(progressNo: counter)
//        counter += 1
//        print("counter: \(counter)")
        viewOrderDetailsTap?()
    }
}

//MARK:- UICollectionView Configuration
extension OrderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: OrderItemCell.self, for: indexPath)
        let productItem = product?[indexPath.row]
       
        cell.item_iv.getImage(imageUrl: productItem?.product?.imagePath ?? "")
        cell.itemName_lbl.text = productItem?.product?.name ?? ""
        cell.quantity_lbl.text = "Quantity: \(productItem?.quantity ?? 0)"
        
    
        switch statusID{
        case 0://wait
            cell.status_lbl.text = "Wait"
            cell.status_lbl.textColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
        case 1://payment
            cell.status_lbl.text = "payment"
            cell.status_lbl.textColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
        case 2://prepering
            cell.status_lbl.text = "prepering"
            cell.status_lbl.textColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
        case 3://on way
            cell.status_lbl.text = "on way"
            cell.status_lbl.textColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
        case 4://done
            cell.status_lbl.text = "Done"
            cell.status_lbl.textColor = .systemGreen
            cell.statusColorView.backgroundColor = .systemGreen
        case 6://cancelled
            cell.status_lbl.text = "Cancelled"
            cell.status_lbl.textColor = .systemRed
            cell.statusColorView.backgroundColor = .systemRed
        default:
            print("ERROR N/A Status ID")
        
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width) / 2, height: collectionView.frame.height)
    }
}

