

import Foundation

struct Bestseller : Codable {
    
	let id : Int?
	let store_id : Int?
	let name_ar : String?
	let name_en : String?
	let image : String?
	let description_ar : String?
	let description_en : String?
	let price : Double?
	let price_after_discount : Double?
	let stock : Int?
	let imagePath : String?
	let name : String?
	let description : String?
	let colors : [Colors]?
	let sizes : [Sizes]?
	let categories : [Categories]?
	let subcategories : [Subcategories]?
	let store : Store?
	let images : [Images]?
	let in_wishlist : Int?
	let in_cart : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case store_id = "store_id"
		case name_ar = "name_ar"
		case name_en = "name_en"
		case image = "image"
		case description_ar = "description_ar"
		case description_en = "description_en"
		case price = "price"
		case price_after_discount = "price_after_discount"
		case stock = "stock"
		case imagePath = "imagePath"
		case name = "name"
		case description = "description"
		case colors = "colors"
		case sizes = "sizes"
		case categories = "categories"
		case subcategories = "subcategories"
		case store = "store"
		case images = "images"
		case in_wishlist = "in_wishlist"
		case in_cart = "in_cart"
	}



}
