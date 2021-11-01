
import Foundation

struct Cart_items : Codable {
    
	let id : Int?
	let cart_id : Int?
	let product_id : Int?
	let size_id : Int?
	let price : Int?
	let quantity : Int?
	let product : Product?
	let size : Size?
	let cartcolors : [Cartcolors]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case cart_id = "cart_id"
		case product_id = "product_id"
		case size_id = "size_id"
		case price = "price"
		case quantity = "quantity"
		case product = "product"
		case size = "size"
		case cartcolors = "cartcolors"
	}


}
