//
//  FilterVC.swift
//  Ward
//
//  Created by Shadi Elattar on 9/26/21.
//

import UIKit
import SwiftRangeSlider

protocol FilterData: class  {
    func filterProduct (rate: Int, color: [String], priceFrom: Double, priceTo: Double)
}

class FilterVC: UIViewController {
    
    @IBOutlet weak var rateTableView: UITableView!
    @IBOutlet weak var applyFilter: UIButton!
    @IBOutlet weak var colorCollV: UICollectionView!
    @IBOutlet weak var priceSlider: RangeSlider!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var typeOfFlowersCollV: UICollectionView!
    
    var from: Double = 0.0
    var to: Double = 0.0
    
    var tableSideData = [
        (name: "4 and above",id:4, star: #imageLiteral(resourceName: "4")),
        (name:  "3 and above",id:3, star: #imageLiteral(resourceName: "3")),
        (name: "2 and above",id:2, star: #imageLiteral(resourceName: "2")),
        (name: "1 and above",id:1, star: #imageLiteral(resourceName: "1")),
    ]
    var indexPathArr: Int = 0
    var rateID: Int = 4
    
    
    
    var colors: [Color] = []
    var indexPathArrColor: [Int] = []
    var colorID: [String] = []
    
    
    var typeOfFlower = [
        "BABY ORCHID",
        "CHRYSANTHEMUMS",
        "GERBERA",
        "ROSES",
        "LILIES",
        "SPIDER",
        "TULIPS"
    ]
    
    var indexPathTypeOfFlowers: [Int] = [0]
    var typeOfFlowersID: [String] = ["0"]
    
    weak var delegate: FilterData?
    
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
        getColor()
        tableViewConfiguration()
        collectionViewConfiguration()
    }
    
    private func setupView(){
        applyFilter.setView(corner: 12)
        
        let lowerPrice = self.priceSlider.lowerValue
        let upperPrice = self.priceSlider.upperValue
        
        price_lbl.text = "price : \(lowerPrice.rounded(toPlaces: 2)) Sr - \(upperPrice.rounded(toPlaces: 2)) Sr"
    }
    
    
    private func tableViewConfiguration(){
        rateTableView.delegate = self
        rateTableView.dataSource = self
        rateTableView.registerNIB(cell: RateCell.self)
    }
    
    private func collectionViewConfiguration(){
        //Color Collection view
        colorCollV.delegate = self
        colorCollV.dataSource = self
        colorCollV.registerNIB(ColorCell.self)
        
        //Type of flower Collection view
        typeOfFlowersCollV.delegate = self
        typeOfFlowersCollV.dataSource = self
        typeOfFlowersCollV.registerNIB(TypeOfFlowersCell.self)
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
    
    private func getColor(){
        APIManagerGetColor.getColor { result in
            if result.status == 200{
                print("Successfully get color")
                self.colors = result.data ?? []
                self.colorCollV.reloadData()
            }else{
                print("Failure get color")
            }
        }
    }
    
    
    @IBAction func clearFilter(_ sender: Any) {
        indexPathArr = 10
        indexPathArrColor = [-1]
        indexPathTypeOfFlowers = [-1]
        
        rateTableView.reloadData()
        colorCollV.reloadData()
        typeOfFlowersCollV.reloadData()
    }
    
    @IBAction func ResetAgeRange_AC(_ sender: Any) {
        
        let lowerPrice = self.priceSlider.lowerValue
        let upperPrice = self.priceSlider.upperValue
        
        self.from = lowerPrice.rounded(toPlaces: 2)
        self.to = upperPrice.rounded(toPlaces: 2)
        
        
        price_lbl.text = "price : \(lowerPrice.rounded(toPlaces: 2)) Sr - \(upperPrice.rounded(toPlaces: 2)) Sr"
    }
    
    @IBAction func back_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyFilterTapped(_ sender: Any) {
        print("rateID: \(rateID)")
        print("ColorID: \(colorID)")
        print("from: \(self.from), to: \(self.to)")
        print("TypeOfFlower: \(typeOfFlowersID)")
       
        delegate?.filterProduct(rate: rateID, color: colorID, priceFrom: self.from, priceTo: self.to)
        self.navigationController?.popViewController(animated: true)
        
    }
}


//MARK:- UITableView Configuration:
extension FilterVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSideData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as RateCell
        cell.rateImag_iv.image = tableSideData[indexPath.row].star
        cell.rateText_lbl.text = tableSideData[indexPath.row].name
        if indexPathArr == (indexPath.row){
            cell.check_iv.image = #imageLiteral(resourceName: "Component 622 – 1")
        }else{
            cell.check_iv.image = #imageLiteral(resourceName: "Ellipse 1131")
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPathArr == (indexPath.row){
            indexPathArr = 0
            let id = tableSideData[indexPath.row].id
            rateID = id
        }else{
            indexPathArr = indexPath.row
            let id = tableSideData[indexPath.row].id
            rateID = id
        }
        
        rateTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}


//MARK:- UICollectionView Configuration:
extension FilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollV{
            return colors.count
        }else{
            return typeOfFlower.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorCollV{
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
            let cell = collectionView.dequeue(cell: TypeOfFlowersCell.self, for: indexPath)
            cell.text_lbl.text = typeOfFlower[indexPath.row]
            
            if indexPathTypeOfFlowers.contains(indexPath.row){
                cell.viewX.borderWidth = 1
                cell.viewX.borderColor = .mainColor
                cell.viewX.backgroundColor = .white
                cell.text_lbl.textColor = .mainColor
            }else{
                cell.viewX.borderWidth = 0
                cell.viewX.backgroundColor = .rgb(red: 233, green: 234, blue: 236)
                cell.text_lbl.textColor = .black
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollV{
            if indexPathArrColor.contains(indexPath.row){
                indexPathArrColor.remove(at:  indexPathArrColor.firstIndex(of: indexPath.row)!)
                let id = colors[indexPath.row].id ?? 0
                colorID.remove(at: colorID.firstIndex(of: "\(id)")!)
            }else{
                indexPathArrColor.append(indexPath.row)
                let id = colors[indexPath.row].id
                colorID.append("\(id)" ?? "")
            }
            
            colorCollV.reloadData()
        }else{
            if indexPathTypeOfFlowers.contains(indexPath.row){
                indexPathTypeOfFlowers.remove(at:  indexPathTypeOfFlowers.firstIndex(of: indexPath.row)!)
                let id = typeOfFlower[indexPath.row]
                typeOfFlowersID.remove(at:  typeOfFlowersID.firstIndex(of:"\(indexPath.row)")!)
            }else{
                indexPathTypeOfFlowers.append(indexPath.row)
                let id = typeOfFlower[indexPath.row]
                typeOfFlowersID.append("\(id)")
                
            }
            typeOfFlowersCollV.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == colorCollV{
            return CGSize(width: 50, height: 50)
        }else{
            let label = UILabel(frame: CGRect.zero)
            let title = typeOfFlower[indexPath.row]
            label.text = title
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10 , height: 25)
        }
        
    }
    
}
