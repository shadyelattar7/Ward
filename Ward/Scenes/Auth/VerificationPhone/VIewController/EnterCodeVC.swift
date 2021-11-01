//
//  EnterCodeVC.swift
//  Stahad
//
//  Created by Shadi Elattar on 7/15/21.
//

import UIKit
import SVProgressHUD

class EnterCodeVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var next_btn: UIButton!
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var phoneNo_tf: UILabel!
    
    var joinas = 1
    var codePhone = ""
    var phoneNum = ""
    var code: String?
    var isRegister = false
    
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
        txt1.delegate = self
        txt2.delegate = self
        txt3.delegate = self
        txt4.delegate = self
        
        txt1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txt2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txt3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txt4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
        txt1.keyboardType = UIKeyboardType.decimalPad
        txt2.keyboardType = UIKeyboardType.decimalPad
        txt3.keyboardType = UIKeyboardType.decimalPad
        txt4.keyboardType = UIKeyboardType.decimalPad
        
        txt1.becomeFirstResponder()
        
        next_btn.setView(corner: 12)
        
        //    back_btn.fixImgDiirection()
        
        phoneNo_tf.text = "\(self.codePhone)\(self.phoneNum)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        if (textField == self.txt1){
            
            let currentString: NSString = txt1?.text! as! NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if(textField == self.txt2){
            let currentString: NSString = txt2?.text! as! NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if(textField == self.txt3){
            let currentString: NSString = txt3?.text! as! NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if(textField == self.txt4){
            let currentString: NSString = txt4?.text! as! NSString
            let newString: NSString = currentString.replacingCharacters(in: range
                                                                        , with: string) as NSString
            return newString.length <= maxLength
        }
        
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        if(textField == self.txt1){
            if(txt1.text?.utf8.count == 1){
                txt2.becomeFirstResponder()
                
            }
        }
        if(textField == self.txt2){
            if(txt2.text?.utf8.count == 1){
                txt3.becomeFirstResponder()
            }
        }
        if(textField == self.txt3){
            if(txt3.text?.utf8.count == 1){
                txt4.becomeFirstResponder()
                
            }
        }
        if(textField == self.txt4){
            if(txt4.text?.utf8.count == 1){
                txt4.endEditing(true)
            }
        }
        
    }
    
    private func confirmCode(code: String){
        SVProgressHUD.show()
        let phone = self.codePhone + self.phoneNum
        print("Phone: \(phone)")
        APIManagerConfirmCode.confirmCode(phone: phone, code: code) { result in
            SVProgressHUD.dismiss()
            if result.status == 200 {
                print("Successfully confirm code")
                
                if self.isRegister{
                    let sb = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                    sb.phone = self.phoneNum
                    sb.countryCode = self.codePhone
                    self.navigationController?.pushViewController(sb, animated: true)
                }else{
                    let sb = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
                    sb.phone = "\(self.codePhone)\(self.phoneNum)"
                    self.navigationController?.pushViewController(sb, animated: true)
                
                }
                
                
              
            }else{
                print("Failure confirm code")
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        let firesthalfCode = self.txt1.text! + self.txt2.text! + self.txt3.text!
        let newCode = firesthalfCode + self.txt4.text!
        self.code = newCode
        print(newCode)
        confirmCode(code: newCode)
    }
    
}
