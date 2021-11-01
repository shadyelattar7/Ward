//
//  EnterPhoneNumVC.swift
//  Stahad
//
//  Created by Shadi Elattar on 7/15/21.
//

import UIKit
import ADCountryPicker
import SVProgressHUD
class EnterPhoneNumVC: UIViewController, ADCountryPickerDelegate {

    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phone_tf: UITextField!
    @IBOutlet weak var next_btn: UIButton!
    @IBOutlet weak var cuntryImage_OT: UIImageView!
    @IBOutlet weak var cuntryCode_OT: UILabel!
    @IBOutlet weak var title_lbl: UILabel!
    
    
    let picker = ADCountryPicker()
    var countryCode = "+966"
    var mobile : String?
    var phoneWithoutZero = ""
    var titleX: String = ""
    var isRegister: Bool = false
    
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
    }
    
    private func setupView(){
        title_lbl.text = titleX
//        phoneView.setView(corner: 12)
        next_btn.setView(corner: 12)
        
        phone_tf.addTarget(self, action: #selector(handleEditText), for: .editingChanged)
        
//        phone_tf.fixTextAligment()
    }

    @objc func handleEditText (){
        phoneWithoutZero = phone_tf.text!

        if  phoneWithoutZero.first == "0" {
            phone_tf.text = phoneWithoutZero

            if phoneWithoutZero.prefix(2) != "0"{
                phoneWithoutZero.remove(at: phoneWithoutZero.startIndex)
            }
            phone_tf.text = phoneWithoutZero
        }
    }
    
    private func sendSmsCode(){
        SVProgressHUD.show()
        let phone = countryCode + phone_tf.text!
        APIManagerSendSmsCode.SendSmsCode(phone: phone) { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                print("Successfully send Sms")
                let sb = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EnterCodeVC") as! EnterCodeVC
                sb.phoneNum = self.phone_tf.text!
                sb.codePhone = self.countryCode
                sb.isRegister = self.isRegister
                self.navigationController?.pushViewController(sb, animated: true)
            }else{
                print("Failure send Sms")
            }
        }
    }

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SelectCuntryCode_AC(_ sender: Any) {
        print("tabed")
        
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        
        /// delegate
        picker.delegate = self as! ADCountryPickerDelegate
        
        /// Optionally, set this to display the country calling codes after the names
        picker.showCallingCodes = true
        
        /// Flag to indicate whether country flags should be shown on the picker. Defaults to true
        picker.showFlags = true
        
        /// The nav bar title to show on picker view
        picker.pickerTitle = "Select a Country"
        
        /// The default current location, if region cannot be determined. Defaults to US
        picker.defaultCountryCode = "US"
        
        /// Flag to indicate whether the defaultCountryCode should be used even if region can be deteremined. Defaults to false
        picker.forceDefaultCountryCode = false
        
        /// The text color of the alphabet scrollbar. Defaults to black
        picker.alphabetScrollBarTintColor = UIColor.black
        
        /// The background color of the alphabet scrollar. Default to clear color
        picker.alphabetScrollBarBackgroundColor = UIColor.clear
        
        /// The tint color of the close icon in presented pickers. Defaults to black
        picker.closeButtonTintColor = UIColor.black
        
        /// The font of the country name list
        picker.font = UIFont(name: "Helvetica Neue", size: 15)
        
        /// The height of the flags shown. Default to 40px
        picker.flagHeight = 40
        
        /// Flag to indicate if the navigation bar should be hidden when search becomes active. Defaults to true
        picker.hidesNavigationBarWhenPresentingSearch = true
        
        /// The background color of the searchbar. Defaults to lightGray
        picker.searchBarBackgroundColor = UIColor.lightGray
        
        
        self.present(pickerNavigationController, animated: true, completion: nil)
        
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String ) {
        print(dialCode)
        print(code)
        print(name)
        self.cuntryCode_OT.text = dialCode
        self.cuntryImage_OT.image =  picker.getFlag(countryCode: code)
        self.countryCode = dialCode
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
        guard let phone = phone_tf.text, !phone.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        
        sendSmsCode()
    }
    
}
