

import Foundation

struct Categories : Codable {
	let id : Int?
	let name_en : String?
	let name_ar : String?
	let image : String?
	let name : String?
	let imagePath : String?
	let sub_categories : [Sub_categories]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name_en = "name_en"
		case name_ar = "name_ar"
		case image = "image"
		case name = "name"
		case imagePath = "imagePath"
		case sub_categories = "sub_categories"
	}


}
