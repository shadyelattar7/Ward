
import Foundation

struct BaseOrderData : Codable {
	let status : Int?
	let orders : Orders?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case orders = "orders"
	}



}
