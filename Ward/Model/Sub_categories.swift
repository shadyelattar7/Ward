

import Foundation
struct Sub_categories : Codable {
	let id : Int?
	let name_en : String?
	let name_ar : String?
	let image : String?
	let category_id : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name_en = "name_en"
		case name_ar = "name_ar"
		case image = "image"
		case category_id = "category_id"
	}

}
