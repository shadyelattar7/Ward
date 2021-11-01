//
//  AddToCartManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/12/21.
//

import Foundation
import Alamofire

class APIManagerAddToCart{
    
    static func addToCart (product_id: Int,store_id: Int,quantity: Int,sizeId: Int,cart_color_ids: [Int], completion: @escaping (_ Category: BaseResponse<BaseCart>) -> ()){
        
        let url = URLs.addToCart
        
         let token = UDHelper.token
        print("token: \(token)")
        
        let parameters = [
            "product_id": product_id,
            "store_id": store_id,
            "quantity": quantity,
            "size_id": sizeId,
            "cart_color_ids": cart_color_ids
        ] as [String : Any]
        
        
        print("Parameters: \(parameters)")
        
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
                    let categories = try JSONDecoder().decode(BaseResponse<BaseCart>.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}
