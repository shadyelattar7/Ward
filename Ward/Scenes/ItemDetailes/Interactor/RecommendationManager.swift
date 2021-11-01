//
//  RecommendationManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/3/21.
//

import Foundation
import Alamofire


struct BaseResponseData : Codable {
    let status : Int?
    let message: String?
    let data : DataProduct?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct DataProduct : Codable {
    let products : [Bestseller]?

    enum CodingKeys: String, CodingKey {

        case products = "products"
    }

  
}


class APIManagerRecommendationProductsManager{
    
    static func getRecommendationProducts (store_id: String, completion: @escaping (_ Category: BaseResponseData) -> ()){
        
        let url = URLs.RecommendationProducts(store_id)
        
        let token = UDHelper.token
        
        let headerS: HTTPHeaders  = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
            switch response.result{
                
            case .failure(let error):
                print("Error while fetching ProductList: \(error)")
            //   completion(nil)
            case .success(_):
           //        print(response.value)
                guard let data = response.data else {
                    print("Error whiles fetching data: didn't get any data from API")
                    //  completion(nil)
                    return
                }
                do{
                    let categories = try JSONDecoder().decode(BaseResponseData.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}
