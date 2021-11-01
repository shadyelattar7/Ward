//
//  EditProfileVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/26/21.
//

import UIKit
import SVProgressHUD

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePic_iv: CircleImageView!
    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    
    var profileImage = UIImage()
    let picker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        
        profilePic_iv.getImage(imageUrl: UDHelper.imagePath)
        username_tf.placeholder = UDHelper.name
        email_tf.placeholder = UDHelper.mail
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
        picker.delegate = self
    }
    
    private func updateProfile(){
        SVProgressHUD.show()
        APIManagerUpdateProfile.updateProfile(name: username_tf.text!, email: email_tf.text!, phone: UDHelper.phone) { result in
            SVProgressHUD.dismiss()
            if result.status == 200{
                ToastManager.shared.showToast(message:"The operation was successful.", view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                ToastManager.shared.showToast(message: result.message ?? "update profile failure", view: self.view, postion: .top, backgroundColor: .systemRed)
            }
        }
    }
    
    @IBAction func pickImageTapped(_ sender: Any) {
        if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, Gallery is not accessible.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :     Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            
            self.profilePic_iv.contentMode = .scaleAspectFill
            self.profileImage = pickedImage
            self.profilePic_iv.image = self.profileImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func updateProfileTapped(_ sender: Any) {
        updateProfile()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        print("Change password")
        let sb = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(sb, animated: true)
    }
}
