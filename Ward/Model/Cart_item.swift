

import Foundation

struct Cart_item : Codable {
	let product_id : String?
	let size_id : String?
	let quantity : Int?
	let price : Int?
	let cart_id : Int?
	let id : Int?

	enum CodingKeys: String, CodingKey {

		case product_id = "product_id"
		case size_id = "size_id"
		case quantity = "quantity"
		case price = "price"
		case cart_id = "cart_id"
		case id = "id"
	}


}
