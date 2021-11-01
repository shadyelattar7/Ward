

import Foundation

struct User : Codable {
    
	let id : Int?
	let name : String?
	let email : String?
	let email_verified_at : String?
	let phone : String?
	let type : Int?
	let imagePath : String?
    let default_address : Address?
    
	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case email = "email"
		case email_verified_at = "email_verified_at"
		case phone = "phone"
		case type = "type"
		case imagePath = "imagePath"
        case default_address = "default_address"
	}



}
