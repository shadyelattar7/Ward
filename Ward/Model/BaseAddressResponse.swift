//
//  BaseAddressResponse.swift
//  Ward
//
//  Created by Shadi Elattar on 10/19/21.
//

import Foundation

struct BaseAddressResponse : Codable {
    let status : Int?
    let addresses : [Address]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case addresses = "addresses"
    }


}
