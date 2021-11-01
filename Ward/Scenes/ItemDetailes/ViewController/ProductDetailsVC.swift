//
//  ProductDetailsVC.swift
//  Ward
//
//  Created by Shadi Elattar on 9/27/21.
//

import UIKit

class ProductDetailsVC: UIViewController {
    
    @IBOutlet weak var colorCollection: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    
    
    var colors: [Colors] = []
    var indexPathArrColor: [Int] = []
    var colorID: [Int] = []
    
    
    
    var typeOfSize: [Sizes] = []
    var indexPathArrtypeOfSize: Int = 0
    var typeOfSizeID: String = "0"
    
    
    var selectColorTap : (([Int])-> Void)?
    var selectSizeTap : ((Int)-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        getSize()
        collectionViewConfiguration()
    }
    
    private func setupView(){
        
    }
    
    private func collectionViewConfiguration(){
        colorCollection.delegate = self
        colorCollection.dataSource = self
        colorCollection.registerNIB(ColorCell.self)
        
        sizeCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        sizeCollectionView.registerNIB(SizeCell.self)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
//    private func getSize(){
//        APIManagerSize.getSize { result in
//            if result.status == 200 {
//                print("get size successfully")
//                self.typeOfSize = result.data ?? []
//                self.sizeCollectionView.reloadData()
//            }else{
//                print("get size failure")
//            }
//        }
//    }
    
    
    
}

//MARK:- UICollectionView Configuration:
extension ProductDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollection{
            return colors.count
        }else{
            return typeOfSize.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorCollection{
            let cell = collectionView.dequeue(cell: ColorCell.self, for: indexPath)
            let color = colors[indexPath.row].code
            cell.viewX.backgroundColor = UIColor.init(color ?? "" , alpha: 1)
            if indexPathArrColor.contains(indexPath.row){
                cell.mark_iv.isHidden = false
            }else{
                cell.mark_iv.isHidden = true
            }
            return cell
        }else{
            let cell = collectionView.dequeue(cell: SizeCell.self, for: indexPath)
            cell.sizeTitle_lbl.text = typeOfSize[indexPath.row].name_en
        
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollection{ //Type Of Color
//            if indexPathArrColor == (indexPath.row){
//                colorID = ""
//            }else{
//                indexPathArrColor = indexPath.row
//                let id = colors[indexPath.row].id
//                print(colors[indexPath.row])
//                colorID = "\(id ?? 0)"
//                selectColorTap?("\(id ?? 0)")
//            }
            if indexPathArrColor.contains(indexPath.row){
                indexPathArrColor.remove(at:  indexPathArrColor.firstIndex(of: indexPath.row)!)
                let id = colors[indexPath.row].id ?? 0
                colorID.remove(at: colorID.firstIndex(of: id)!)
            }else{
                indexPathArrColor.append(indexPath.row)
                let id = colors[indexPath.row].id
                colorID.append(id ?? 0)
                selectColorTap?(colorID)
            }
        
            colorCollection.reloadData()
            
        }else{ // Type Of Size
            
            print("Size: \(typeOfSize[indexPath.row].id ?? 0)")
            let id = typeOfSize[indexPath.row].id ?? 0
            selectSizeTap?(id)
        }
        
       
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
}
