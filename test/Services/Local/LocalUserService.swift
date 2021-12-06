//
//  LocalUserService.swift
//  test
//
//  Created by Admin on 05/12/2021.
//

import Foundation
import RxSwift

protocol LocalUserService {
    func users() -> Single<[UserResponse]>
    func userDetail(login: String) -> Single<UserDetailResponse?>
    func update(users: [UserResponse]) -> Single<Void>
    func update(userDetail: UserDetailResponse) -> Single<Void>
}
