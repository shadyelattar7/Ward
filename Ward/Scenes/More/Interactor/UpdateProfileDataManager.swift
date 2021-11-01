//
//  UpdateProfileDataManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/26/21.
//

import Foundation
import Alamofire


class APIManagerUpdateProfile{
    
    static func updateProfile (name: String,email: String,phone: String,completion: @escaping (_ Category: BaseResponse<User>) -> ()){
        
        let url = URLs.updateProfile
        
        let token = UDHelper.token
        print("Token: \(UDHelper.token)")
        
        let parameters = [
            "name": name,
            "email": email,
            "phone": phone
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
                    let userData = try JSONDecoder().decode( BaseResponse<User>.self, from: data)
                    
                    UDHelper.name = userData.data?.name ?? ""
                    UDHelper.phone = userData.data?.phone ?? ""
                    UDHelper.mail = userData.data?.email ?? ""
                    
                    completion(userData)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}
