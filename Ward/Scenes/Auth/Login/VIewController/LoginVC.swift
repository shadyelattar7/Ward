//
//  LoginVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/4/21.
//

import UIKit
import ADCountryPicker
import SVProgressHUD

class LoginVC: UIViewController, ADCountryPickerDelegate {

    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phone_tf: UITextField!
    @IBOutlet weak var cuntryImage_OT: UIImageView!
    @IBOutlet weak var cuntryCode_OT: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var password_btn: UIButton!
    
    let picker = ADCountryPicker()
    var countryCode = "+966"
    var mobile : String?
    var phoneWithoutZero = ""
    private var hidePass = false
     
    
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
        phoneView.setView(corner: 12)
      //  passwordView.setView(corner: 12)
        login_btn.setView(corner: 12)
        phone_tf.addTarget(self, action: #selector(handleEditText), for: .editingChanged)
        
//        phone_tf.fixTextAligment()
//        password_tf.fixTextAligment()
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

    
    @IBAction func hidePasswordBtnTapped(_ sender: Any) {
        password_tf.isSecureTextEntry = hidePass
        hidePass.toggle()
    }
    
    
    @IBAction func SelectCuntryCode_AC(_ sender: Any) {
        print("tabed")
        
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        
        /// delegate
        picker.delegate = self
        
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
    
    private func login(){
        SVProgressHUD.show()
        
        let phone = countryCode + phoneWithoutZero
        print("phone: \(phone)")
        ApiManagerLogin.Login(phone: phone, password: password_tf.text ?? "") { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Successfully login")
            }else{
                print("ERRORS: \(result.errors ?? [])")
                print("Messages: \(result.messages ?? [])")
                ToastManager.shared.showToast(message: result.message ?? "", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
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
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let phoneNo = phone_tf.text, !phoneNo.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        
        guard let password = password_tf.text, !password.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        
        login()
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        print("123")
        let sb = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EnterPhoneNumVC") as! EnterPhoneNumVC
        sb.titleX = "Create a new account"
        sb.isRegister = true
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func forgetPassTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EnterPhoneNumVC") as! EnterPhoneNumVC
        sb.titleX = "Forgot your password ?"
        sb.isRegister = false
        self.navigationController?.pushViewController(sb, animated: true)
    }
}
