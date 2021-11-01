//
//  LoginManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/12/21.
//

import Foundation
import Alamofire

class ApiManagerLogin{
    
    static func Login (phone: String, password: String, completion: @escaping (_ Category: BaseResponse<BaseLogin>) -> ()){
        
        let url = URLs.login
        
        let parameters = [
            "email_or_phone": phone,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            switch response.result{
                
            case .failure(let error):
                print("Error while fetching ProductList: \(error)")
            //   completion(nil)
            case .success(_):
                // print(response.value)
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
                        UDHelper.mail = userData.data?.user?.email ?? ""
                        let lat = userData.data?.user?.default_address?.address_lat ?? ""
                        UDHelper.UserCoordinates.lat = Double(lat) ?? 0.0
                        let long = userData.data?.user?.default_address?.address_lng ?? ""
                        UDHelper.UserCoordinates.lat = Double(long) ?? 0.0
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
