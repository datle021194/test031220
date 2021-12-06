//
//  Coordinator.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    var childCoordinator: [Coordinator] { get set }
}
