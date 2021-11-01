//
//  BaseLogin.swift
//  Ward
//
//  Created by Shadi Elattar on 10/12/21.
//

import Foundation

struct BaseLogin : Codable {
    let access_token : String?
    let token_type : String?
    let expires_at : String?
    let user : User?

    enum CodingKeys: String, CodingKey {

        case access_token = "access_token"
        case token_type = "token_type"
        case expires_at = "expires_at"
        case user = "user"
    }

}
