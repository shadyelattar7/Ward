//
//  SetDefaultAddressManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/24/21.
//

import Foundation
import Alamofire

class APIManagerSetDefualtAddress{
    
    static func setDefualtAddress (address_id: Int, completion: @escaping (_ Category: BaseResponse<BaseWhishlist>) -> ()){
        
        let url = URLs.setDefaultAddress
        
         let token = UDHelper.token
        
        let parameters = [
            "address_id": address_id
        ]
        
          let headerS: HTTPHeaders  = [
              "Authorization": "Bearer \(token)"
          ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
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
                    let categories = try JSONDecoder().decode(BaseResponse<BaseWhishlist>.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
    
}
