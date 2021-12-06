//
//  UserServiceImp.swift
//  test
//
//  Created by Admin on 04/12/2021.
//

import Foundation
import RxSwift
import Alamofire

struct UserServiceImp: UserService {
    private let decodeError = NSError(
        domain: "",
        code: 0,
        userInfo: [NSLocalizedDescriptionKey: "decode error"]
    )
    private let disposeBag = DisposeBag()
    
    func users() -> Single<[UserResponse]> {
        return Single<[UserResponse]>.create(subscribe: { single in
            guard let url = URL(string: API.users()) else { fatalError("invalid url") }
            let urlRequest = URLRequest(url: url)
            
            URLSession.shared
                .rx
                .response(request: urlRequest)
                .subscribe(onNext: { (_, data) in
                    let decodedResponse = try? JSONDecoder().decode([UserResponse].self, from: data)

                    if let decodedResponse = decodedResponse {
                        single(.success(decodedResponse))
                    } else {
                        single(.failure(decodeError))
                    }
                }, onError: { error in
                    single(.failure(error))
                })
                .disposed(by: disposeBag)
            
            return Disposables.create()
        })
    }
    
    func userDetail(login: String) -> Single<UserDetailResponse> {
        return Single<UserDetailResponse>.create(subscribe: { single in
            guard let url = URL(string: API.userDetail(login: login)) else { fatalError("invalid url")}
            let urlRequest = URLRequest(url: url)
            
            URLSession.shared.rx
                .response(request: urlRequest)
                .subscribe(onNext: { (_, data) in
                    let decodedResponse = try? JSONDecoder().decode(UserDetailResponse.self, from: data)

                    if let decodedResponse = decodedResponse {
                        single(.success(decodedResponse))
                    } else {
                        single(.failure(decodeError))
                    }
                }, onError: { error in
                    single(.failure(error))
                })
                .disposed(by: disposeBag)
            
            return Disposables.create()
        })
    }
}
