//
//  ServiceMock.swift
//  testTests
//
//  Created by Admin on 04/12/2021.
//

import Foundation
import RxSwift

class UserServiceMock: UserService {
    func users() -> Single<[UserResponse]> {
        return Single<[UserResponse]>.create(subscribe: { single in
            single(.success(usersModelMock))
            return Disposables.create()
        })
    }
    
    func userDetail(login: String) -> Single<UserDetailResponse> {
        return Single<UserDetailResponse>.create(subscribe: { single in
            single(.success(userDetailModelMock))
            return Disposables.create()
        })
    }
}

class LocalUserServiceMock: LocalUserService {
    func users() -> Single<[UserResponse]> {
        return Single<[UserResponse]>.create(subscribe: { single in
            single(.success(usersModelMock))
            return Disposables.create()
        })
    }
    
    func userDetail(login: String) -> Single<UserDetailResponse?> {
        return Single<UserDetailResponse?>.create(subscribe: { single in
            single(.success(userDetailModelMock))
            return Disposables.create()
        })
    }
    
    func update(users: [UserResponse]) -> Single<Void> {
        return Single<Void>.create(subscribe: { single in
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func update(userDetail: UserDetailResponse) -> Single<Void> {
        return Single<Void>.create(subscribe: { single in
            single(.success(()))
            return Disposables.create()
        })
    }
}

class InternetConnectivityMock: InternetConnectivity {
    var isConnected: Bool { true }
}
