//
//  TabMenuWireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class MenuWireFrame: WireFrame {
    
    typealias ViewController = MenuContentViewContorller
    
    let viewController: MenuContentViewContorller
    
    required init(viewController: MenuContentViewContorller) {
       self.viewController = viewController
    }
    
    func showContentView(key: String) {
        
        let transitVC = UserListViewControllerBuilder.build(key)

        self.viewController.addChildViewController(transitVC)
        transitVC.view.frame = viewController.view.frame
        self.viewController.view.addSubview(transitVC.view)
        transitVC.didMove(toParentViewController: transitVC)
    }
    
}
