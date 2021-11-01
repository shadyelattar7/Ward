//
//  CreateOrderManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/17/21.
//

import Foundation
import Alamofire

class APIManagerCreateOrder{
    
    static func createOrder (store_id: String,address_id: String,payment_method: String,delivery_date: String,delivery_time: String, sender: String,receiver: String,note: String,completion: @escaping (_ Category: BaseResponse<CreatOrder>) -> ()){
        
        let url = URLs.createOrder
        
        print("url: \(url)")
        
        let token = UDHelper.token
        
        print("token: \(token)")
        
        let parameters = [
            "store_id": store_id,
            "address_id": address_id,
            "payment_method": payment_method,
            "delivery_date": delivery_date,
            "delivery_time": delivery_time,
            "sender": sender,
            "receiver": receiver,
            "note": note,
        ]
        
        print("parameters: \(parameters)")
        
        let headerS: HTTPHeaders  = [
            "Authorization": "Bearer \(token)"
        ]
        
        print("headerS: \(headerS)")
        
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
                    let categories = try JSONDecoder().decode(BaseResponse<CreatOrder>.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}
