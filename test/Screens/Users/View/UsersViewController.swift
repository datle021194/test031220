//
//  UsersViewController.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: BaseViewController {
    @IBOutlet weak var usersTableView: UITableView!
    var viewmodel: UsersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User List"
        
        setupUsersTableView()
        
        guard let viewmodel = viewmodel else { return }
        observeViewStatus(from: viewmodel)
        viewmodel.viewDidLoad.onNext(())
    }
    
    private func setupUsersTableView() {
        let nibCell = UINib.init(nibName: "UserItemCell", bundle: nil)
        usersTableView.register(nibCell, forCellReuseIdentifier: "UserItemCellId")
        usersTableView.rowHeight = UITableView.automaticDimension
        usersTableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        usersTableView.refreshControl = refreshControl
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                refreshControl.endRefreshing()
                self?.viewmodel?.pullToRefresh.onNext(())
            })
            .disposed(by: disposeBag)
        
        usersTableView.rx.itemSelected
            .map({ $0.row })
            .bind(to: viewmodel!.itemSelected)
            .disposed(by: disposeBag)

        viewmodel?
            .usersObservable
            .bind(to: usersTableView.rx.items(cellIdentifier: "UserItemCellId")) { index, data, cell in
                (cell as! UserItemCell).data = data
            }
            .disposed(by: disposeBag)

    }
}
