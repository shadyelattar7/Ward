//
//  SaveAddressManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/17/21.
//

import Foundation
import Alamofire

class APIManagerAddAddress{
    
    static func addAddress (name: String,area: String,building_type: String,floor_number: String,building_name_number: String, landmark: String,apartment_number: String,phone_number: String,address_lat: Double,address_lng: Double,is_default: Int ,completion: @escaping (_ Category: BaseResponse<BaseAddress>) -> ()){
        
        let url = URLs.addAddress
        
        print("url: \(url)")
        
        let token = UDHelper.token
        
        print("token: \(token)")
        
        let parameters = [
            "name": name,
            "area": area,
            "building_type": building_type,
            "floor_number": floor_number,
            "building_name_number": building_name_number,
            "landmark": landmark,
            "apartment_number": apartment_number,
            "phone_number": phone_number,
            "address_lat": address_lat,
            "address_lng": address_lng,
            "is_default": is_default
        ] as [String : Any]
        
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
                  print(response.value)
                guard let data = response.data else {
                    print("Error whiles fetching data: didn't get any data from API")
                    //  completion(nil)
                    return
                }
                do{
                    let categories = try JSONDecoder().decode(BaseResponse<BaseAddress>.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}
