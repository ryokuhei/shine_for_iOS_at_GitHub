//
//  RootWireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/06.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

struct RootWireFrame: WireFrame {
    
    typealias ViewController = RootViewController
    
    weak var viewController: ViewController!

    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func showLoginViewController() {
        let loginVC = LoginViewControllerBuilder.build()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        transitionViewController(toViewController: navigationController)
        
    }
    
    func showTopViewController() {
        let topVC = TopViewControllerBuilder.build()
        let navigationController = UINavigationController(rootViewController: topVC)
        
        transitionViewController(toViewController: navigationController)
    }
    
    private func transitionViewController(toViewController vc: UIViewController) {
        
        // move
        self.viewController.addChildViewController(vc)
        vc.view.frame = self.viewController.view.bounds
        self.viewController.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self.viewController)
        
        // remove
        self.viewController.current.willMove(toParentViewController: self.viewController)
        self.viewController.current.view.removeFromSuperview()
        self.viewController.current.removeFromParentViewController()
        
        self.viewController.current = vc
    }
    
}
