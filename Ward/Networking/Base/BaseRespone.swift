//
//  BaseRespone.swift
//  Ward
//
//  Created by Shadi Elattar on 10/4/21.
//

import Foundation

struct BaseRespon : Codable {
    let status : Int?
    let message : String?
    let errors : [String]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case errors = "errors"
    }

}
