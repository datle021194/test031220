//
//  API.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import Foundation
import RxSwift

struct API {
    static private let baseURL = "https://api.github.com"
    
    static func users() -> String {
        baseURL + "/users"
    }
    
    static func userDetail(login: String) -> String {
        baseURL + "/users/" + login
    }
}
