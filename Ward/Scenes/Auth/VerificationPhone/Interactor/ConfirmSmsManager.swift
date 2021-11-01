//
//  ConfirmSmsManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/4/21.
//

import Foundation
import Alamofire

class APIManagerConfirmCode{
    
    static func confirmCode (phone: String, code: String, completion: @escaping (_ Category: BaseRespon) -> ()){
        
        let url = URLs.main + "users/sms/confirm?phone=\(phone)&confirm_code=\(code)"
        
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            let statusCode = response.response?.statusCode
            print("Status Code: \(statusCode ?? 0)")
            
            switch response.result{
                
            case .failure(let error):
                print("Error while fetching ProductList: \(error)")
            //   completion(nil)
            case .success(_):
                   print(response.value)
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

