//
//  UserDetailViewModel.swift
//  test
//
//  Created by Admin on 04/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class UserDetailViewModel: BaseViewModel {
    // view's observables
    var avatar: ControlProperty<String?> {
        return ControlProperty(values: avatarSubject.asObservable(),
                               valueSink: avatarSubject.asObserver())
    }
    var name: ControlProperty<String?> {
        return ControlProperty(values: nameSubject.asObservable(),
                               valueSink: nameSubject.asObserver())
    }
    var location: ControlProperty<String?> {
        return ControlProperty(values: locationSubject.asObservable(),
                               valueSink: locationSubject.asObserver())
    }
    var bio: ControlProperty<String?> {
        return ControlProperty(values: bioSubject.asObservable(),
                               valueSink: bioSubject.asObserver())
    }
    var publicRepoNumber: ControlProperty<String> {
        return ControlProperty(values: publicRepoNumberSubject.asObservable(),
                               valueSink: publicRepoNumberSubject.asObserver())
    }
    var followersNumber: ControlProperty<String> {
        return ControlProperty(values: followersNumberSubject.asObservable(),
                               valueSink: followersNumberSubject.asObserver())
    }
    var followingNumber: ControlProperty<String> {
        return ControlProperty(values: followingNumberSubject.asObservable(),
                               valueSink: followingNumberSubject.asObserver())
    }
    
    // view's events
    let viewDidLoad = PublishSubject<Void>()
    
    // observers
    private let avatarSubject = BehaviorSubject<String?>(value: nil)
    private let nameSubject = BehaviorSubject<String?>(value: nil)
    private let locationSubject = BehaviorSubject<String?>(value: nil)
    private let bioSubject = BehaviorSubject<String?>(value: nil)
    private let publicRepoNumberSubject = BehaviorSubject<String>(value: "0")
    private let followersNumberSubject = BehaviorSubject<String>(value: "0")
    private let followingNumberSubject = BehaviorSubject<String>(value: "0")
    
    //
    private lazy var concurrentQueue = ConcurrentDispatchQueueScheduler.init(qos: .background)
    
    // dependencies
    let remoteService: UserService!
    let localService: LocalUserService!
    let internetConnectivity: InternetConnectivity!
    
    init(login: String,
         remoteService: UserService,
         localService: LocalUserService,
         internetConnectivity: InternetConnectivity
    ) {
        self.remoteService = remoteService
        self.localService = localService
        self.internetConnectivity = internetConnectivity
        
        super.init()
        
        let shareViewDidLoad = viewDidLoad.share()
        fetchOnlineData(trigger: shareViewDidLoad, login: login)
        fetchOfflineData(trigger: shareViewDidLoad, login: login)
        
        fetchOnlineData(trigger: pullToRefresh, login: login)
    }
    
    private func fetchOnlineData(trigger: Observable<Void>, login: String) {
        let weakSelf = self
        
        trigger
            .filter({ _ in
                weakSelf.internetConnectivity.isConnected
            })
            .do(onNext: { _ in
                weakSelf.viewStatus.onNext(.loading)
            })
            .flatMapLatest({ _ in
                weakSelf.remoteService.userDetail(login: login)
            })
            .observe(on: MainScheduler.instance)
            .do(onNext: { response in
                weakSelf.bindToView(response)
            }, onError: { error in
                weakSelf.viewStatus.onNext(.normal)
                weakSelf.viewStatus.onNext(.alert(message: error.localizedDescription))
            })
            .flatMapLatest({ response in
                weakSelf.localService.update(userDetail: response).asDriver(onErrorJustReturn: ())
            })
            .subscribe(onNext: { response in
                weakSelf.viewStatus.onNext(.normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchOfflineData(trigger: Observable<Void>, login: String) {
        trigger
            .filter({ [weak self] _ in
                !(self?.internetConnectivity.isConnected ?? true)
            })
            .do(onNext: { [weak self] _ in
                self?.viewStatus.onNext(.loading)
            })
            .flatMapLatest({ [weak self] _ in
                (self?.localService
                    .userDetail(login: login)
                    ?? Single<UserDetailResponse?>.just(nil))
                    .asDriver(onErrorJustReturn: nil)
            })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                if let response = response { self?.bindToView(response) }
                self?.viewStatus.onNext(.normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToView(_ response: UserDetailResponse) {
        avatarSubject.onNext(response.avatarURL)
        nameSubject.onNext(response.name)
        locationSubject.onNext(response.location)
        bioSubject.onNext(response.bio)
        publicRepoNumberSubject.onNext("\(response.publicRepos ?? 0)")
        followersNumberSubject.onNext("\(response.followers ?? 0)")
        followingNumberSubject.onNext("\(response.following ?? 0)")
    }
}
