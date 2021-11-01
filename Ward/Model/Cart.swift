

import Foundation
struct Cart : Codable {
    
    let id : Int?
    let store_id : Int?
    let user_id : Int?
    let total : Int?
    let cart_items : [Cart_items]?
    let store : Store?

	enum CodingKeys: String, CodingKey {

        case id = "id"
        case store_id = "store_id"
        case user_id = "user_id"
        case total = "total"
        case cart_items = "cart_items"
        case store = "store"
	}


}
