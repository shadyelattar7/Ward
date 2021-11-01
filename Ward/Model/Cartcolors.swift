
import Foundation
struct Cartcolors : Codable {
	let id : Int?
	let item_id : Int?
	let color_id : Int?
	let created_at : String?
	let updated_at : String?
	let color : Color?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case item_id = "item_id"
		case color_id = "color_id"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case color = "color"
	}



}
