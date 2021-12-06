//
//  UsersViewModel.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import Foundation
import RxSwift

class UsersViewModel: BaseViewModel {
    // view's observables
    var usersObservable: Observable<[UserItemViewModel]> { usersSubject.asObservable() }
    
    // view's events
    private(set) lazy var viewDidLoad = PublishSubject<Void>()
    private(set) lazy var itemSelected = PublishSubject<Int>()
    
    // dependencies
    let remoteService: UserService!
    let localService: LocalUserService!
    let internetConnectivity: InternetConnectivity!
    
    //
    private let usersSubject = PublishSubject<[UserItemViewModel]>()
    private lazy var model: [UserResponse] = []
    private lazy var concurrentQueue = ConcurrentDispatchQueueScheduler.init(qos: .background)
    
    init(remoteService: UserService,
         localService: LocalUserService,
         internetConnectivity: InternetConnectivity
    ) {
        self.remoteService = remoteService
        self.localService = localService
        self.internetConnectivity = internetConnectivity
        
        super.init()
        
        let shareViewDidLoad = viewDidLoad.share()
        fetchOnlineData(trigger: shareViewDidLoad)
        fetchOfflineData(trigger: shareViewDidLoad)
        
        fetchOnlineData(trigger: pullToRefresh)
    }
    
    func userLogin(at index: Int) -> String? {
        return model[index].login
    }
    
    private func fetchOnlineData(trigger: Observable<Void>) {
        trigger
            .filter({ [weak self] _ in
                self?.internetConnectivity.isConnected ?? false
            })
            .do(onNext: { [weak self] _ in
                self?.viewStatus.onNext(.loading)
            })
            .flatMapLatest({ [weak self] _ in
                self?.remoteService.users() ?? Single<[UserResponse]>.just([])
            })
            .map({ response in
                response.sorted(by: { (item1, item2) in
                    (item1.login ?? "").lowercased().compare(
                        (item2.login ?? "").lowercased()
                    ) == .orderedAscending
                })
            })
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] response in
                self?.model = response
            }, onError: { [weak self] error in
                self?.onReceivedError(error)
            })
            .flatMapLatest({ [weak self] response in
                self?.localService.update(users: response).asDriver(onErrorJustReturn: ()) ?? Single<Void>.just(()).asDriver(onErrorJustReturn: ())
            })
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.usersSubject.onNext(weakSelf.model.map({
                    UserItemViewModel.converted(from: $0)
                }))
                weakSelf.viewStatus.onNext(.normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchOfflineData(trigger: Observable<Void>) {
        trigger
            .filter({ [weak self] _ in
                !(self?.internetConnectivity.isConnected ?? true)
            })
            .do(onNext: { [weak self] _ in
                self?.viewStatus.onNext(.loading)
            })
            .flatMapLatest({ [weak self] _ in
                self?.localService.users() ?? Single<[UserResponse]>.just([])
            })
            .map({ response in
                response.sorted(by: { (item1, item2) in
                    (item1.login ?? "").lowercased().compare(
                        (item2.login ?? "").lowercased()
                    ) == .orderedAscending
                })
            })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let weakSelf = self else { return }
                weakSelf.model = response
                weakSelf.usersSubject.onNext(response.map({
                    UserItemViewModel.converted(from: $0)
                }))
                weakSelf.viewStatus.onNext(.normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func onReceivedError(_ error: Error) {
        viewStatus.onNext(.normal)
        viewStatus.onNext(.alert(message: error.localizedDescription))
    }
}
