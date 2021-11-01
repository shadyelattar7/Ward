//
//  Rate.swift
//  Ward
//
//  Created by Shadi Elattar on 9/28/21.
//

import Foundation

struct rating : Codable {
    
    let id : Int?
    let user_id : Int?
    let store_id : Int?
    let order_id: Int?
    let rating: Int?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case store_id = "store_id"
        case order_id = "order_id"
        case rating = "rating"
    }

}
