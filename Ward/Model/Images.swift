

import Foundation
struct Images : Codable {
	let id : Int?
	let product_id : Int?
	let image : String?
	let imagePath : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case product_id = "product_id"
		case image = "image"
		case imagePath = "imagePath"
	}



}
