
import Foundation

struct Address : Codable {
    
	let name : String?
	let user_id : Int?
	let area : String?
	let building_type : String?
	let floor_number : String?
	let building_name_number : String?
	let apartment_number : String?
	let shipping_note : String?
	let landmark : String?
	let address_lat : String?
	let address_lng : String?
	let phone_number : String?
	let isDefault : Int?
	let updated_at : String?
	let created_at : String?
	let id : Int?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case user_id = "user_id"
		case area = "area"
		case building_type = "building_type"
		case floor_number = "floor_number"
		case building_name_number = "building_name_number"
		case apartment_number = "apartment_number"
		case shipping_note = "shipping_note"
		case landmark = "landmark"
		case address_lat = "address_lat"
		case address_lng = "address_lng"
		case phone_number = "phone_number"
		case isDefault = "isDefault"
		case updated_at = "updated_at"
		case created_at = "created_at"
		case id = "id"
	}

}
