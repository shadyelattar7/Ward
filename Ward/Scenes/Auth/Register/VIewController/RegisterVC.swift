//
//  RegisterVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/4/21.
//

import UIKit
import SVProgressHUD
class RegisterVC: UIViewController {

    @IBOutlet weak var name_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var phoneNo_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var confirmPassword_tf: UITextField!
    
    private var hidePass = false
    private var hideConfirmPass = false
    var phone: String = ""
    var countryCode: String = ""
    
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
    }
    
    private func setupView(){
        phoneNo_tf.text = countryCode + phone
    }
    
    private func saveAddress(lat: Double, long: Double){
      //  SVProgressHUD.show()
        APIManagerAddAddress.addAddress(name: "", area: "", building_type: "", floor_number: "", building_name_number: "", landmark: "", apartment_number: "", phone_number: "", address_lat: lat, address_lng: long, is_default: 1) { result in
           SVProgressHUD.dismiss()
            if result.status == 201{
                print("Save Address Succesfuuly")
                UDHelper.addressID = result.data?.address?.id ?? 0
                ToastManager.shared.showToast(message: "Save Address Successfully", view: self.view, postion: .top, backgroundColor: .systemGreen)
            }else{
                print("Message: \(result.message ?? "")")
                print("Error: \(result.errors ?? [])")
                print("Save Address Failure")
            }
        }
    }
    
    
    private func register(){
        SVProgressHUD.show()
        ApiManagerRegister.register(name: name_tf.text ?? "", email: email_tf.text ?? "", phone: phoneNo_tf.text ?? "", password: password_tf.text ?? "", confirm_password: confirmPassword_tf.text ?? "") { result in
        //    SVProgressHUD.dismiss()
            if result.status == 201 {
              print("Successfully register")
                let lat = UDHelper.UserCoordinates.lat
                let long = UDHelper.UserCoordinates.long
                self.saveAddress(lat: lat, long: long)
            }else{
                print("ERRORS: \(result.errors ?? [])")
                print("Messages: \(result.messages ?? [])")
                print("Message: \(result.message ?? "")")
                ToastManager.shared.showToast(message: result.message ?? "", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func hidePasswordBtnTapped(_ sender: Any) {
        password_tf.isSecureTextEntry = hidePass
        hidePass.toggle()
    }
    
    @IBAction func hideConformPassBtnTapped(_ sender: Any) {
        confirmPassword_tf.isSecureTextEntry = hideConfirmPass
        hideConfirmPass.toggle()
    }

    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let name = name_tf.text, !name.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        guard let email = email_tf.text, !email.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }

        guard let password = password_tf.text, !password.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        
        
        guard let password = password_tf.text, let confirmPass = confirmPassword_tf.text , password == confirmPass else {
            ToastManager.shared.showToast(message: "Please password not equal confirmPass", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        
        register()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
