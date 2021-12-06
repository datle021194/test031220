//
//  UserService.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import Foundation
import RxSwift

protocol UserService {
    func users() -> Single<[UserResponse]>
    func userDetail(login: String) -> Single<UserDetailResponse>
}
