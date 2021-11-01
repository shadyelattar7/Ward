//
//  RateVC.swift
//  ModelsProvider
//
//  Created by Ayman Ata on 2/10/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import SVProgressHUD


class RateVC: UIViewController, UITextViewDelegate {
    
    init() {
        super.init(nibName: "RateVC", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var selectedFeeling: Feeling = .awesome
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var feelingButtons: [UIButton]!
   
    @IBOutlet weak var rate_btn: UIButton!
    @IBOutlet weak var cancel_btn: UIButton!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var comment_tv: UITextView!
    
    
    var rates: Int = 0
    var order_id: Int = 0
    var store_id: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1333333333, alpha: 0.5)
        containerView.layer.cornerRadius = 20
        rate_btn.setView(corner: 12)
        cancel_btn.setView(corner: 12)
      
        
        commentView.setView(corner: 12)
        commentView.layer.borderWidth = 1
        commentView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        comment_tv.placeholder = "اكتب تعليقك"
    }
    
    
    private func postRates (){
        SVProgressHUD.show()
        APIManagerRate.rate(rate: "\(rates)", order_id: "\(order_id)", store_id: "\(store_id)") { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                ToastManager.shared.showToast(message: "Sucessfully Rate".localized, view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let window = UIApplication.shared.keyWindow else {return}
                    let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarVC")
                    window.rootViewController = productVC
                }
            }else{
                ToastManager.shared.showToast(message: result.errors?[0] ?? "Somthing Wrong", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
        
    }
    
   
    
    @IBAction func feelingsBtnTapped(_ sender: UIButton) {
        feelingButtons.forEach({ $0.setImage(UIImage(named: "emojy-Ar\($0.tag)"), for: .normal) })
        sender.setImage(UIImage(named: "emojy-Ar-filled\(sender.tag)"), for: .normal)
        selectedFeeling = Feeling.allCases[sender.tag]
        
        switch selectedFeeling{
        case .angry:
            rates = 1
        case .notBad:
            rates = 2
        case .good:
            rates = 3
        case .happy:
            rates = 4
        case .awesome:
            rates = 5
        }
        
    }
    
    

    
    
    @IBAction func action_btn(_ sender: UIButton) {
        postRates()
      
        print("Rate: \(rates)")

    }
    
    
    @IBAction func cancel_btn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

fileprivate enum Feeling: CaseIterable {
    case angry
    case notBad
    case good
    case happy
    case awesome
}

/*
 Angry -> 1
 notBad -> 2
 good -> 3
 happy -> 4
 awesome -> 5
 */
