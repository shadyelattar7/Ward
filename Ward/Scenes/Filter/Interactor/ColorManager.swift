//
//  ColorManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/25/21.
//

import Foundation
import Alamofire

class APIManagerGetColor{
    
    static func getColor (completion: @escaping (_ Category: BaseResponse<[Color]>) -> ()){
        
        let url = URLs.main + "colors"

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
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
                    let categories = try JSONDecoder().decode(BaseResponse<[Color]>.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}

