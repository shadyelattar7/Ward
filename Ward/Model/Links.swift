

import Foundation
struct Links : Codable {
	let url : String?
	let label : String?
	let active : Bool?

	enum CodingKeys: String, CodingKey {

		case url = "url"
		case label = "label"
		case active = "active"
	}


}
