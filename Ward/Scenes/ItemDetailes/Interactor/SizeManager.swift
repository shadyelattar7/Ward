//
//  SizeManager.swift
//  Ward
//
//  Created by Shadi Elattar on 10/12/21.
//

import Foundation
import Alamofire

class APIManagerSize{
    
    static func getSize (completion: @escaping (_ Category: BaseResponse<[Size]>) -> ()){
        
        let url = URLs.size
        
        
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
                    let categories = try JSONDecoder().decode(BaseResponse<[Size]>.self, from: data)
                    completion(categories)
                    
                }catch{
                    print("Error trying to decode response Projects: \(error)")
                    //   completion(nil)
                }
            }
        }
    }
}

