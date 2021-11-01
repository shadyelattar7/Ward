

import Foundation

struct Orders : Codable {
    
	let current_page : Int?
	let data : [OrdersData]?
	let first_page_url : String?
	let from : Int?
	let last_page : Int?
	let last_page_url : String?
	let links : [Links]?
	let next_page_url : String?
	let path : String?
	let per_page : Int?
	let prev_page_url : String?
	let to : Int?
	let total : Int?

	enum CodingKeys: String, CodingKey {

		case current_page = "current_page"
		case data = "data"
		case first_page_url = "first_page_url"
		case from = "from"
		case last_page = "last_page"
		case last_page_url = "last_page_url"
		case links = "links"
		case next_page_url = "next_page_url"
		case path = "path"
		case per_page = "per_page"
		case prev_page_url = "prev_page_url"
		case to = "to"
		case total = "total"
	}


}
