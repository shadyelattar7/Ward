//
//  Order.swift
//  Ward
//
//  Created by Shadi Elattar on 10/18/21.
//

import Foundation

struct OrdersData : Codable {
    
    let id : Int?
    let store_id : Int?
    let user_id : Int?
    let address_id : Int?
    let payment_method : String?
    let sender : String?
    let receiver : String?
    let total_price : Int?
    let delivery_date : String?
    let delivery_time : String?
    let status_id : Int?
    let note : String?
    let created_at : String?
    let order_items : [Cart_items]?
    let store : User?
    let user : User?
    let address : Address?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case store_id = "store_id"
        case user_id = "user_id"
        case address_id = "address_id"
        case payment_method = "payment_method"
        case sender = "sender"
        case receiver = "receiver"
        case total_price = "total_price"
        case delivery_date = "delivery_date"
        case delivery_time = "delivery_time"
        case status_id = "status_id"
        case note = "note"
        case created_at = "created_at"
        case order_items = "order_items"
        case store = "store"
        case user = "user"
        case address = "address"
    }


}
