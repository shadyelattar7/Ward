//
//  BaseResponse.swift
//  NetworkLayer
//
//  Created by Elattar on 10/11/20.
//  Copyright © 2020 Shadi Elattar. All rights reserved.
//

import Foundation


class BaseResponse<T: Codable>: Codable{
    
    let status: Int?
    let message: String?
    let messages: [String]?
    let errors: [String]?
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case data =  "data"
        case messages = "messages"
        case errors = "errors"
    }
}
