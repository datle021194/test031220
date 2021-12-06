//
//  UserDetailViewController.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import UIKit
import RxSwift
import RxKingfisher

class UserDetailViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var publicRepoNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    var viewmodel: UserDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        guard let viewmodel = viewmodel else { return }
        observeViewStatus(from: viewmodel)
        
        // setup avatar
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.layer.masksToBounds = true

        // setup scroll view
        let refreshControl = UIRefreshControl()
        scrollView.refreshControl = refreshControl

        // refresh
        refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                refreshControl.endRefreshing()
                self?.viewmodel?.pullToRefresh.onNext(())
            })
            .disposed(by: disposeBag)

        // setup data binding
        viewmodel.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewmodel.location
            .bind(to: locationLabel.rx.text)
            .disposed(by: disposeBag)

        viewmodel.bio
            .bind(to: bioLabel.rx.text)
            .disposed(by: disposeBag)

        viewmodel.publicRepoNumber
            .bind(to: publicRepoNumberLabel.rx.text)
            .disposed(by: disposeBag)

        viewmodel.followersNumber
            .bind(to: followersNumberLabel.rx.text)
            .disposed(by: disposeBag)

        viewmodel.followingNumber
            .bind(to: followingNumberLabel.rx.text)
            .disposed(by: disposeBag)

        viewmodel.avatar.map({ url in URL(string: url ?? "") })
            .bind(to: avatarImageView.kf.rx.image())
            .disposed(by: disposeBag)

        // forward event
        viewmodel.viewDidLoad.onNext(())
    }
}
