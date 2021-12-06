//
//  UserDetailResponse.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import Foundation

struct UserDetailResponse: Codable {
    let login, name, location, avatarURL, bio: String?
    let publicRepos, followers, following: Int?

    enum CodingKeys: String, CodingKey {
        case login, name, location, bio
        case followers, following
        case avatarURL = "avatar_url"
        case publicRepos = "public_repos"
    }
    
    static func converted(from userDetail: UserDetailMO) -> UserDetailResponse {
        return UserDetailResponse(
            login: userDetail.login,
            name: userDetail.name,
            location: userDetail.location,
            avatarURL: userDetail.avatarURL,
            bio: userDetail.bio,
            publicRepos: Int(userDetail.publicRepos),
            followers: Int(userDetail.followers),
            following: Int(userDetail.following)
        )
    }
}
