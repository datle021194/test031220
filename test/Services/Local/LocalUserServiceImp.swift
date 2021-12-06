//
//  LocalUserServiceImp.swift
//  test
//
//  Created by Admin on 05/12/2021.
//

import Foundation
import RxSwift

struct LocalUserServiceImp: LocalUserService {
    private let disposeBag = DisposeBag()
    
    func users() -> Single<[UserResponse]> {
        return Single<[UserResponse]>.create(subscribe: { single in
            CoredataUserManager
                .shared
                .users()
                .subscribe(onSuccess: { listUserMO in
                    let convertedUser = listUserMO.map({
                        return UserResponse.converted(from: $0)
                    })
                    single(.success(convertedUser))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: disposeBag)
            
            return Disposables.create()
        })
    }
    
    func userDetail(login: String) -> Single<UserDetailResponse?> {
        return Single<UserDetailResponse?>.create(subscribe: { single in
            CoredataUserManager
                .shared
                .userDetail(id: login)
                .subscribe(onSuccess: { userDetailMO in
                    if let userDetailMO = userDetailMO {
                        let convertedUserDetail = UserDetailResponse.converted(from: userDetailMO)
                        single(.success(convertedUserDetail))
                    } else {
                        single(.success(nil))
                    }
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: disposeBag)
            
            return Disposables.create()
        })
    }
    
    func update(users: [UserResponse]) -> Single<Void> {
        return CoredataUserManager
            .shared
            .insertOrUpdate(users: users)
    }
    
    func update(userDetail: UserDetailResponse) -> Single<Void> {
        return CoredataUserManager
            .shared
            .insertOrUpdate(userDetail: userDetail)
    }
}
