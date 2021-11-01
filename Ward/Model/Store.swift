

import Foundation
struct Store : Codable {
	let user_id : Int?
	let lat : String?
	let lng : String?
	let delivery_fee : Double?
	let commercial_number : String?
	let bank_name : String?
	let commercial_images : String?
	let iban : String?
	let location_id : Int?
	let overall_rating : Int?
	let cover_image : String?
	let rateStore : Int?
	let images : [String]?
	let delivery : Double?
	let rating : [rating]?
	let user : User?

	enum CodingKeys: String, CodingKey {

		case user_id = "user_id"
		case lat = "lat"
		case lng = "lng"
		case delivery_fee = "delivery_fee"
		case commercial_number = "commercial_number"
		case bank_name = "bank_name"
		case commercial_images = "commercial_images"
		case iban = "iban"
		case location_id = "location_id"
		case overall_rating = "overall_rating"
		case cover_image = "cover_image"
		case rateStore = "rateStore"
		case images = "images"
		case delivery = "delivery"
		case rating = "rating"
		case user = "user"
	}


}
