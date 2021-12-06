//
//  UserItemViewModel.swift
//  test
//
//  Created by Admin on 04/12/2021.
//

import Foundation

struct UserItemViewModel {
    let avatar: String?
    let login: String?
    let htmlURL: String?
    
    static func converted(from model: UserResponse) -> UserItemViewModel {
        return UserItemViewModel(avatar: model.avatarURL, login: model.login, htmlURL: model.htmlURL)
    }
}
