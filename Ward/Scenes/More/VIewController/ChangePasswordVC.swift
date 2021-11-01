//
//  ChangePasswordVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/26/21.
//

import UIKit
import SVProgressHUD

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var newPassword_tf: UITextField!
    @IBOutlet weak var confirmPassword_tf: UITextField!
    
    private var hidePass = false
    private var hideNewPass = false
    private var hideConfirmPass = false
    
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


    }
    
    func validateTextInput() -> Bool{
        
        let validate = Validation.shared.validate(values:
            (.password, self.password_tf.text! , password_tf),
            (.password, self.newPassword_tf.text! , newPassword_tf),
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

    
       private func changePassword(){
        let oldPassword = password_tf.text!
        let newPassword = newPassword_tf.text!
        let confirm = confirmPassword_tf.text!
        SVProgressHUD.show()
        APIManagerChangePassword.changePassword(oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirm) { (result) in
            SVProgressHUD.dismiss()
            if result.status == 200{
                ToastManager.shared.showToast(message:"The operation was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                ToastManager.shared.showToast(message: result.message ?? "Failure change password", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
    
    @IBAction func hidePasswordBtnTapped(_ sender: UIButton) {
        
        if sender.tag == 0{
            password_tf.isSecureTextEntry = hidePass
            hidePass.toggle()
            
        }else if sender.tag == 1{
            newPassword_tf.isSecureTextEntry = hideNewPass
            hideNewPass.toggle()
            
        }else{
            confirmPassword_tf.isSecureTextEntry = hideConfirmPass
            hideConfirmPass.toggle()
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func saveTapped(_ sender: Any) {
        if validateTextInput(){
            changePassword()
        }
    }
    
}
