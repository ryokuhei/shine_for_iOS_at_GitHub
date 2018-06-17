//
//  SlideMenuWireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/07.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

struct SlideMenuWireFrame: WireFrame {

    typealias ViewController = SlideMenuViewController
    
    var viewController: ViewController!
    
    init(viewController: SlideMenuViewController) {
        self.viewController = viewController
    }

    func showLoginViewController() {
        
        let loginViewController = LoginViewControllerBuilder.build()
        let naviVC = UINavigationController(rootViewController: loginViewController)
        AppDelegate.shared.rootViewController.current = naviVC
    }
}
