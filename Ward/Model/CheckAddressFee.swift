//
//  CheckAddressFee.swift
//  Ward
//
//  Created by Shadi Elattar on 10/17/21.
//

import Foundation

struct CheckAddressFee : Codable {
    
    let delivery_fee : Int?
    let user_address_exist : Bool?
    let address_complete: Bool?

    enum CodingKeys: String, CodingKey {
        case delivery_fee = "delivery_fee"
        case user_address_exist = "user_address_exist"
        case address_complete = "address_complete"
    }

}
