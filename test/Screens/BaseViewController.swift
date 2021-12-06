//
//  BaseViewController.swift
//  test
//
//  Created by Admin on 04/12/2021.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    private(set) lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.stopAnimating()
    }
    
    func observeViewStatus(from viewmodel: BaseViewModel) {
        viewmodel
            .viewStatus
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .normal:
                    self?.view.isUserInteractionEnabled = true
                    self?.activityIndicator?.stopAnimating()
                case .loading:
                    self?.view.isUserInteractionEnabled = false
                    self?.activityIndicator?.startAnimating()
                case .alert(let message):
                    self?.view.isUserInteractionEnabled = true
                    self?.showAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert(title: String? = nil, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}
