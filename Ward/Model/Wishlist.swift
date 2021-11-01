

import Foundation

struct Wishlist : Codable {
	let product_id : String?
	let user_id : Int?
	let id : Int?

	enum CodingKeys: String, CodingKey {
		case product_id = "product_id"
		case user_id = "user_id"
		case id = "id"
	}

}
