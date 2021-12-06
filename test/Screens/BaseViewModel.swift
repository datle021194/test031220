//
//  BaseViewModel.swift
//  test
//
//  Created by Admin on 04/12/2021.
//

import Foundation
import RxSwift

enum ViewStatus {
    case normal
    case loading
    case alert(message: String)
}

class BaseViewModel {
    private(set) lazy var viewStatus = BehaviorSubject<ViewStatus>(value: .normal)
    private(set) lazy var pullToRefresh = PublishSubject<Void>()
    private(set) lazy var disposeBag = DisposeBag()
}
