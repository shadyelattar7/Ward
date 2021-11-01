//
//  ForgetPasswordVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/28/21.
//

import UIKit
import SVProgressHUD

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var phone_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var confirmPassword_tf: UITextField!
    
    private var hideNewPass = false
    private var hideConfirmPass = false
    var phone: String = ""
    
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
        phone_tf.isUserInteractionEnabled = false
        phone_tf.text = phone
    }
    
    private func forgetPassword(){
        let phone = phone_tf.text!
        let newPassword = password_tf.text!
        let confirm = confirmPassword_tf.text!
        SVProgressHUD.show()
        APIManagerForgetPassword.forgetPassword(phone: phone, newPassword: newPassword, confirmPassword: confirm) { (result) in
            SVProgressHUD.dismiss()
            if result.status == 200{
                ToastManager.shared.showToast(message:"The operation was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else{
                ToastManager.shared.showToast(message: result.message ?? "Failure change password", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
 
    
    func validateTextInput() -> Bool{
        
        let validate = Validation.shared.validate(values:
            (.password, self.password_tf.text! , password_tf),
            (.password, self.confirmPassword_tf.text! , confirmPassword_tf)
        )
        
        switch validate.1 {
        case .success:
            break
        case .failure(_, let message):
            validate.0.handleInvalidCasefor(message: message.rawValue)
            return false
        }
        return true
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hidePasswordBtnTapped(_ sender: UIButton) {
        
        if sender.tag == 1{
            password_tf.isSecureTextEntry = hideNewPass
            hideNewPass.toggle()
            
        }else{
            confirmPassword_tf.isSecureTextEntry = hideConfirmPass
            hideConfirmPass.toggle()
        }
    }

    @IBAction func saveTapped(_ sender: Any) {
        if validateTextInput(){
            forgetPassword()
        }
    }
    
}
