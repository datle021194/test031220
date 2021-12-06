//
//  AppCoordinator.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import UIKit
import RxSwift

class AppCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    var childCoordinator: [Coordinator] = []
    
    private let disposeBag = DisposeBag()
    
    init() {
        let remoteService = UserServiceImp()
        let localService = LocalUserServiceImp()
        let internetConnectivity = InternetConnectivityManager()

        let usersViewModel = UsersViewModel(
            remoteService: remoteService,
            localService: localService,
            internetConnectivity: internetConnectivity
        )
        
        usersViewModel
            .itemSelected
            .map({ index in usersViewModel.userLogin(at: index) })
            .subscribe(onNext: { [weak self] login in
                self?.onSelectedLogin(login: login,
                                      remoteService: remoteService,
                                      localService: localService,
                                      internetConnectivity: internetConnectivity
                )
            })
            .disposed(by: disposeBag)

        let usersView = UsersViewController()
        usersView.viewmodel = usersViewModel

        let navigationController = UINavigationController(rootViewController: usersView)
        self.navigationController = navigationController
    }
    
    private func onSelectedLogin(login: String?,
                                 remoteService: UserService,
                                 localService: LocalUserService,
                                 internetConnectivity: InternetConnectivity
    ) {
        guard let login = login else { return }

        let userDetailVM = UserDetailViewModel(
            login: login,
            remoteService: remoteService,
            localService: localService,
            internetConnectivity: internetConnectivity
        )

        let userDetailVC = UserDetailViewController()
        userDetailVC.viewmodel = userDetailVM
        
        navigationController?.show(userDetailVC, sender: nil)
    }
}
