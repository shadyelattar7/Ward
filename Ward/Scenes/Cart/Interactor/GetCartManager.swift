//
//  GetCartManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/13/21.
//

import Foundation
import Alamofire

class APIManagerCart{
    
    static func getCart (completion: @escaping (_ Category: BaseUserCart) -> ()){
        
        let url = URLs.cart
        let token = UDHelper.token
        
        let headerS: HTTPHeaders  = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
            switch response.result{
                
            case .failure(let error):
                print("Error while fetching ProductList: \(error.localizedDescription)")
            //   completion(nil)
            case .success(_):
           //        print(response.value)
                guard let data = response.data else {
                    print("Error whiles fetching data: didn't get any data from API")
                    //  completion(nil)
                    return
                }
                do{
                    let categories = try JSONDecoder().decode(BaseUserCart.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}

