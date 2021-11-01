//
//  RateManager.swift
//  Halak
//
//  Created by Elattar on 3/22/21.
//  Copyright © 2021 Elattar. All rights reserved.
//

import Foundation
import Alamofire

struct BaseRate : Codable {
    let status : Int?
    let message : String?
    let errors: [String]?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case errors = "errors"
    }
}

class APIManagerRate{
    
    static func rate (rate: String,order_id: String,store_id: String ,completion: @escaping (_ Category: BaseRate) -> ()){
        
        let token = UDHelper.token
        
        let url = URLs.main + "order/rating"
                
        let parameters = [
            "store_id":store_id ,
            "order_id": order_id,
            "rating": rate,
          
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
               //   print(response.result.value)
                guard let data = response.data else {
                    print("Error whiles fetching data: didn't get any data from API")
                  //  completion(nil)
                    return
                }
                do{
                    let categories = try JSONDecoder().decode(BaseRate.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response: \(error)")
                 //   completion(nil)
                }
            }
        }
    }
}
