//
//  BaseUserCart.swift
//  Ward
//
//  Created by Shadi Elattar on 10/13/21.
//

import Foundation

struct BaseUserCart : Codable {
    let status : Int?
    let items : [Cart]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case items = "items"
    }


}
