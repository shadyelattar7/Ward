//
//  TargetType.swift
//  NetworkLayer
//
//  Created by Elattar on 10/7/20.
//  Copyright © 2020 Shadi Elattar. All rights reserved.
//

import Foundation
import Alamofire


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Task {
    case requestPlain
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}


protocol TargetType {
    var baseURl: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var task: Task {get}
    var header: [String: String]? {get}
}
