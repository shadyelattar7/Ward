//
//  BaseAPI.swift
//  NetworkLayer
//
//  Created by Elattar on 10/7/20.
//  Copyright © 2020 Shadi Elattar. All rights reserved.
//

import Foundation
import Alamofire

class BaseAPI<T: TargetType>{
    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completion: @escaping (Result<M?, NSError>) -> Void){
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let hearder = Alamofire.HTTPHeaders(target.header ?? [:])
        let params = buildParams(task: target.task)
        
        AF.request(target.baseURl + target.path, method: method, parameters: params.0, encoding: params.1,headers: hearder).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {
                // ADD Some Error
                completion(.failure(NSError()))
                return
            }
            
            if statusCode == 200 {
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Some Error
                    completion(.failure(NSError()))
                    return
                }
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else{
                    // ADD Some Error
                    
                    completion(.failure(NSError()))
                    return
                }
                guard let responseObj =  try? JSONDecoder().decode(M.self, from: theJSONData) else {
                    // ADD Some Error
                    completion(.failure(NSError()))
                    return
                }
                
                completion(.success(responseObj))
                
            }else {
                // ADD Some Error base on status code 404 / 401
                //Error Parsing for the error message from the BE
                let message = "Error Message Parsed From BE"
                let error = NSError(domain: target.baseURl, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                completion(.failure(error))
            }
        }
    }
    
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(let parameters, let encoding):
            return (parameters, encoding)
            
        }
    }
}
