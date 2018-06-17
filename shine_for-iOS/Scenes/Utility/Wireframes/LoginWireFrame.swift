//
//  LoginWireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/06.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

struct LoginWireFrame: WireFrame {
    
    typealias ViewController = LoginViewController
    
    weak var viewController: ViewController!
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func showTopViewController() {
        let topViewController = TopViewControllerBuilder.build()
        let navigationController = UINavigationController(rootViewController: topViewController)
        AppDelegate.shared.rootViewController.current = navigationController
    }
    
}
