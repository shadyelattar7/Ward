//
//  AddToWishlistMananger.swift
//  Ward
//
//  Created by Shadi Elattar on 10/12/21.
//

import Foundation
import Alamofire

class APIManagerAddToWishlist{
    
    static func addToWishlist (product_id: Int, completion: @escaping (_ Category: BaseResponse<BaseWhishlist>) -> ()){
        
        let url = URLs.wishlist
        
         let token = UDHelper.token
        
        let parameters = [
            "product_id": product_id
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
    
    
    static func addSellerToWishlist (store_id: Int, completion: @escaping (_ Category: BaseResponse<BaseWhishlist>) -> ()){
        
        let url = URLs.sellerTowishlist
        
         let token = UDHelper.token
        
        let parameters = [
            "store_id": store_id
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
    
    static func deleteFromWishlist (product_id: Int, completion: @escaping (_ Category: BaseResponse<BaseWhishlist>) -> ()){
        
        let url = URLs.deleteFromWishlist(product_id)
        print("URL: \(url)")
         let token = UDHelper.token
  
          let headerS: HTTPHeaders  = [
              "Authorization": "Bearer \(token)"
          ]
        
        AF.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
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
    
    static func deleteSellerFromWishlist (product_id: Int, completion: @escaping (_ Category: BaseResponse<BaseWhishlist>) -> ()){
        
        let url = URLs.deleteSellerFromWishlist(product_id)
        print("URL: \(url)")
         let token = UDHelper.token
  
          let headerS: HTTPHeaders  = [
              "Authorization": "Bearer \(token)"
          ]
        
        AF.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headerS).responseJSON { (response) in
            
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
