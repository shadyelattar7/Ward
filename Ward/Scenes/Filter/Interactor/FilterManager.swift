//
//  FilterManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/25/21.
//

import Foundation
import Alamofire


class APIManagerFilter{
    
    static func getProductAfterFilter (colorsID: [String],overall_rate: Int,user_lat: Double,user_lng: Double,price_from: Double,price_to: Double,selling: Int,completion: @escaping (_ Category: BaseCategry) -> ()){
        
        let join = colorsID.joined(separator: "%2C")
        
        
        let url = URLs.main + "home/search-products?color_id\(join)=3&overall_rate=\(overall_rate)&user_lat=\(user_lat)&user_lng=\(user_lng)&price_from=\(price_from)&price_to=\(price_to)&selling=\(selling)"
        

        
        let token = UDHelper.token
        
        let headerS: HTTPHeaders  = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
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
                    let categories = try JSONDecoder().decode(BaseCategry.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
    
    static func getProductFromCategoryAfterFilter (colorsID: [String],overall_rate: Int,user_lat: Double,user_lng: Double,price_from: Double,price_to: Double,category_id: Int,subcategory_id: Int,completion: @escaping (_ Category: BaseCategry) -> ()){
        
        let join = colorsID.joined(separator: "%2C")
    
        let url = URLs.main + "home/search-products?category_id=\(category_id)&subcategory_id=\(subcategory_id)&color_id[0]=\(join)&overall_rate=\(overall_rate)&user_lat=\(user_lat)&user_lng=\(user_lng)&price_from=\(price_from)&price_to=\(price_to)"
        let token = UDHelper.token
        
        let headerS: HTTPHeaders  = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
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
                    let categories = try JSONDecoder().decode(BaseCategry.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
    
    static func getFilterInStore (colorsID: [String],overall_rate: Int,user_lat: Double,user_lng: Double,price_from: Double,price_to: Double,selling: Int,storeID: Int,completion: @escaping (_ Category: BaseCategry) -> ()){
        
        let join = colorsID.joined(separator: "%2C")
        
        
        let url = URLs.main + "home/search-products?color_id\(join)=3&overall_rate=\(overall_rate)&user_lat=\(user_lat)&user_lng=\(user_lng)&price_from=\(price_from)&price_to=\(price_to)&selling=\(selling)&store_id=\(storeID)"
        
        
        
        let token = UDHelper.token
        
        let headerS: HTTPHeaders  = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
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
                    let categories = try JSONDecoder().decode(BaseCategry.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
    
}
