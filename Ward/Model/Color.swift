
import Foundation
struct Color : Codable {
	let id : Int?
	let name_ar : String?
	let name_en : String?
	let code : String?
	let name : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name_ar = "name_ar"
		case name_en = "name_en"
		case code = "code"
		case name = "name"
	}
}
