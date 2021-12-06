//
//  AppDelegate.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appCoordinator = AppCoordinator()
        
        // load coredata container
        let _ = CoredataManager.shared.persistentContainer
        CoredataManager.shared.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = appCoordinator!.navigationController
        window!.makeKeyAndVisible()
        
        return true
    }
}

