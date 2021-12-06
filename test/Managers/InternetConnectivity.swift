//
//  InternetConnectivity.swift
//  test
//
//  Created by Admin on 05/12/2021.
//

import Foundation
import Alamofire

protocol InternetConnectivity {
    var isConnected: Bool { get }
}

class InternetConnectivityManager: InternetConnectivity {
    private lazy var reachabilityManager = NetworkReachabilityManager()
    
    var isConnected: Bool {
        return reachabilityManager?.isReachable ?? false
    }
}
