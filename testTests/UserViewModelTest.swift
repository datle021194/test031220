//
//  UserViewModelTest.swift
//  testTests
//
//  Created by Admin on 04/12/2021.
//

import XCTest
import RxSwift

class UserViewModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    let remoteService = UserServiceMock()
    let localService = LocalUserServiceMock()
    let internetConnectivity = InternetConnectivityMock()
    
    
    func testUserNameById() {
        let usersVM  = UsersViewModel(remoteService: remoteService,
                                      localService: localService,
                                      internetConnectivity: internetConnectivity
        )
        
        // given input: user list
        // expected output: the first user has login is 2
        usersVM
            .usersObservable
            .subscribe(onNext: { response in
                XCTAssertEqual(1, response.count)
                XCTAssertEqual(response[0].login, "2")
                
                usersVM.itemSelected.onNext(0)
            })
            .disposed(by: disposeBag)
        
        usersVM
            .itemSelected
            .map({ index in usersVM.userLogin(at: index) })
            .subscribe(onNext: { [weak self] login in
                XCTAssertNotNil(login)
                self?.toDetail(login: login)
            })
            .disposed(by: disposeBag)
        
        usersVM.viewDidLoad.onNext(())
    }
    
    func toDetail(login: String?) {
        XCTAssertNotNil(login)
        
        let userDetailVM = UserDetailViewModel(login: login!,
                                               remoteService: remoteService,
                                               localService: localService,
                                               internetConnectivity: internetConnectivity
        )
        
        // given input: login = 2
        // expected output: hello
        userDetailVM
            .name
            .skip(1)
            .subscribe(onNext: { userName in
                XCTAssertEqual(userName, "hello")
            })
            .disposed(by: disposeBag)
        
        userDetailVM.viewDidLoad.onNext(())
    }
}
