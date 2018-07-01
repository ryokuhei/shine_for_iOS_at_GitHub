//
//  TopFireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class TopWireFrame: WireFrame {
    
    typealias ViewController = TopViewController
    
    let viewController: TopViewController
    
    required init(viewController: TopViewController) {
        self.viewController = viewController
    }
    
    func showAddUserViewController() {
        
        let transitVC = AddUserViewControlerBuilder.build()

        let navVC = UINavigationController(rootViewController: transitVC)
        viewController.present(navVC, animated: true, completion: nil)
        
    }
    
    func showUserDetail(userKey: String, menu group: Group) {
        
        let transitVC = DetailViewControllerBuilder.build(userKey: userKey, menu: group)
        
        let naviVC = UINavigationController(rootViewController: transitVC)
        viewController.present(naviVC, animated: true, completion: nil)
    }

}
