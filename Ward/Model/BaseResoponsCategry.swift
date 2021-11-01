//
//  BaseResoponsCategry.swift
//  Ward
//
//  Created by Shadi Elattar on 9/28/21.
//

import Foundation

struct BaseCategry : Codable {
    let message : String?
    let status : Int?
    let data : [Bestseller]?
    let categories : [Categories]?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case status = "status"
        case data = "data"
        case categories = "categories"
    }


}
