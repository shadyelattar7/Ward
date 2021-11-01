//
//  ChangePasswordManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/26/21.
//

import Foundation
import Alamofire

class APIManagerChangePassword{
    
    static func changePassword (oldPassword: String,newPassword: String,confirmPassword: String,completion: @escaping (_ Category: BaseRespon) -> ()){
        
        let url = URLs.changePassword
        
        let token = UDHelper.token
        print("Token: \(UDHelper.token)")
        
        let parameters = [
            "old_password": oldPassword,
            "password": newPassword,
            "confirm_password": confirmPassword
        ]
        
        
        let headerS: HTTPHeaders  = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
            switch response.result{
            
            case .failure(let error):
                print("Error while fetching ProductList: \(error.localizedDescription)")
            //   completion(nil)
            case .success(_):
                //  print(response.value)
                guard let data = response.data else {
                    print("Error whiles fetching data: didn't get any data from API")
                    //  completion(nil)
                    return
                }
                do{
                    let categories = try JSONDecoder().decode(BaseRespon.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}


class APIManagerForgetPassword{
    
    static func forgetPassword (phone: String,newPassword: String,confirmPassword: String,completion: @escaping (_ Category: BaseRespon) -> ()){
        
        let url = URLs.forgetPassword
        
        let token = UDHelper.token
        print("Token: \(UDHelper.token)")
        
        let parameters = [
            "phone": phone,
            "password": newPassword,
            "confirm_password": confirmPassword
        ]
        
        
        let headerS: HTTPHeaders  = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
            switch response.result{
            
            case .failure(let error):
                print("Error while fetching ProductList: \(error.localizedDescription)")
            //   completion(nil)
            case .success(_):
                //  print(response.value)
                guard let data = response.data else {
                    print("Error whiles fetching data: didn't get any data from API")
                    //  completion(nil)
                    return
                }
                do{
                    let categories = try JSONDecoder().decode(BaseRespon.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}
