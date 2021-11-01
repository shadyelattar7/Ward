//
//  RegisterManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/4/21.
//

import Foundation
import Alamofire

class ApiManagerRegister{
    
    static func register (name: String,email: String, phone: String, password: String,confirm_password: String, completion: @escaping (_ Category: BaseResponse<BaseLogin>) -> ()){
        
        let url = URLs.register
        
        let parameters = [
            "name": name,
            "email": email,
            "phone": phone,
            "password": password,
            "confirm_password": confirm_password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            switch response.result{
                
            case .failure(let error):
                print("Error while fetching ProductList: \(error)")
            //   completion(nil)
            case .success(_):
               //  print(response.value)
                guard let data = response.data else {
                    print("Error whiles fetching data: didn't get any data from API")
                    //  completion(nil)
                    return
                }
                do{
                    let userData = try JSONDecoder().decode(BaseResponse<BaseLogin>.self, from: data)
                    if userData.data?.access_token == nil{
                        print("token has not extiing")
                    }else{
                        print("Token \(userData.data?.access_token ?? "")")
                        UDHelper.token = userData.data?.access_token ?? ""
                        UDHelper.userID = userData.data?.user?.id ?? 0
                        UDHelper.name = userData.data?.user?.name ?? ""
                        UDHelper.imagePath = userData.data?.user?.imagePath ?? ""
                        UDHelper.phone = userData.data?.user?.phone ?? ""
            
                    }
                    completion(userData)
                }catch{
                    print("Error trying to decode response: \(error.localizedDescription)")
                    print("In Filters")
                    //   completion(nil)
                }
            }
        }
    }
    
}
