//
//  UpdateQuantityManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/17/21.
//

import Foundation
import Alamofire

class ApiManagerUpdateQty{
    
    static func updateQuantity (product_id: Int, cart_id: Int,store_id: Int,quantity: Int,completion: @escaping (_ Category: BaseRespon) -> ()){
           
        let url = URLs.updateQuantity
        

        let parameters = [
            "product_id": product_id,
            "cart_id": cart_id,
            "store_id": store_id,
            "quantity": quantity
        ] as [String : Any]
        
        
        let token = UDHelper.token
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
