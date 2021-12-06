//
//  UserResponse.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import Foundation

struct UserResponse: Codable {
    let login, htmlURL, avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
    
    static func converted(from user: UserMO) -> UserResponse {
        return UserResponse(
            login: user.login,
            htmlURL: user.htmlURL,
            avatarURL: user.avatarURL
        )
    }
}
