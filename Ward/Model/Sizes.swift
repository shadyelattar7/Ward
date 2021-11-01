

import Foundation
struct Sizes : Codable {
	let id : Int?
	let name_en : String?
	let name_ar : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name_en = "name_en"
		case name_ar = "name_ar"
	}

}
