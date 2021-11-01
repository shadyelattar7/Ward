//
//  CartDetailesCell.swift
//  Ward
//
//  Created by Shadi Elattar on 10/13/21.
//

import UIKit

class CartDetailesCell: UITableViewCell {

    @IBOutlet weak var productName_lbl: UILabel!
    @IBOutlet weak var colorName_lbl: UILabel!
    @IBOutlet weak var size_lbl: UILabel!
    @IBOutlet weak var productIm_iv: UIImageView!
    @IBOutlet weak var deliveryTime_lbl: UILabel!
    @IBOutlet weak var productPrice_lbl: UILabel!
    
    @IBOutlet weak var btnsStack: UIStackView!
    @IBOutlet weak var selected_lbl: UILabel!
    @IBOutlet weak var arrowImg_iv: UIImageView!
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    @IBOutlet weak var fivethBtn: UIButton!
    @IBOutlet var counterBtns: [UIButton]!
    
    
    var upDownTapped: (()->())?
    var removeTapped: (()->())?
    var selectedQuantityTapped: ((Int)->())?
    
    var isDown: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnsStack.isHidden = true
        arrowImg_iv.image = #imageLiteral(resourceName: "Arrow - down")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
    
      //  upDownStackSetup()
    
    }
    
    
    private func upDownStackSetup(){
        isDown.toggle()
        if isDown{
            UIView.animate(withDuration: 0.5) {
                self.btnsStack.isHidden = false
            }
            arrowImg_iv.image = #imageLiteral(resourceName: "Arrow - up 2")
        }else{
            UIView.animate(withDuration: 0.5) {
                self.btnsStack.isHidden = true
            }
            arrowImg_iv.image = #imageLiteral(resourceName: "Arrow - down")
        }
    }
    
    
    private func selecteQuantitySetup(){
        
    }

    func allBtnsSetupView(tag: Int){
        switch tag {
        case 1:
            firstBtn.backgroundColor = .black
            firstBtn.setTitleColor(.white, for: .normal)
            
            secondBtn.backgroundColor = .white
            secondBtn.setTitleColor(.WGray, for: .normal)
            
            thirdBtn.backgroundColor = .white
            thirdBtn.setTitleColor(.WGray, for: .normal)
            
            fourthBtn.backgroundColor = .white
            fourthBtn.setTitleColor(.WGray, for: .normal)
            
            fivethBtn.backgroundColor = .white
            fivethBtn.setTitleColor(.WGray, for: .normal)
            
        case 2:
            firstBtn.backgroundColor = .white
            firstBtn.setTitleColor(.WGray, for: .normal)
            
            secondBtn.backgroundColor = .black
            secondBtn.setTitleColor(.white, for: .normal)
            
            thirdBtn.backgroundColor = .white
            thirdBtn.setTitleColor(.WGray, for: .normal)
            
            fourthBtn.backgroundColor = .white
            fourthBtn.setTitleColor(.WGray, for: .normal)
            
            fivethBtn.backgroundColor = .white
            fivethBtn.setTitleColor(.WGray, for: .normal)
            
        case 3:
            
            firstBtn.backgroundColor = .white
            firstBtn.setTitleColor(.WGray, for: .normal)
            
            secondBtn.backgroundColor = .white
            secondBtn.setTitleColor(.WGray, for: .normal)
            
            thirdBtn.backgroundColor = .black
            thirdBtn.setTitleColor(.white, for: .normal)
            
            fourthBtn.backgroundColor = .white
            fourthBtn.setTitleColor(.WGray, for: .normal)
            
            fivethBtn.backgroundColor = .white
            fivethBtn.setTitleColor(.WGray, for: .normal)
            
        case 4:
            firstBtn.backgroundColor = .white
            firstBtn.setTitleColor(.WGray, for: .normal)
            
            secondBtn.backgroundColor = .white
            secondBtn.setTitleColor(.WGray, for: .normal)
            
            thirdBtn.backgroundColor = .white
            thirdBtn.setTitleColor(.WGray, for: .normal)
            
            
            fourthBtn.backgroundColor = .black
            fourthBtn.setTitleColor(.white, for: .normal)
            
            fivethBtn.backgroundColor = .white
            fivethBtn.setTitleColor(.WGray, for: .normal)
        case 5:
            firstBtn.backgroundColor = .white
            firstBtn.setTitleColor(.WGray, for: .normal)
            
            secondBtn.backgroundColor = .white
            secondBtn.setTitleColor(.WGray, for: .normal)
            
            thirdBtn.backgroundColor = .white
            thirdBtn.setTitleColor(.WGray, for: .normal)
            
            fourthBtn.backgroundColor = .white
            fourthBtn.setTitleColor(.WGray, for: .normal)
            
            fivethBtn.backgroundColor = .black
            fivethBtn.setTitleColor(.white, for: .normal)
        default:
            print("ERROR N/A")
        
        }
    }
    
    
    @IBAction func counterBtnsTapped(_ sender: UIButton) {
        
        print(sender.tag)
        let tag = sender.tag
        allBtnsSetupView(tag: tag)
        selected_lbl.text = "\(sender.tag)"
        selectedQuantityTapped?(tag)
    }
    
    
    @IBAction func upDown_btn(_ sender: Any) {
        upDownStackSetup()
        upDownTapped?()
    }
    
    @IBAction func remove_btn(_ sender: Any) {
        removeTapped?()
    }
}
