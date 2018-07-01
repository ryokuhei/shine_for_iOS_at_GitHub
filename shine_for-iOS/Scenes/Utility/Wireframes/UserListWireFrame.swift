//
//  UserListWireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/26.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class UserListWireFrame: WireFrame {

    typealias ViewController = UserListViewController
    
    var viewController: UserListViewController
    
    required init(viewController: UserListViewController) {
        self.viewController = viewController
    }
    
    func showUserDetail(userKey: String, menu group: Group) {
        
        let transiteVC = DetailViewControllerBuilder.build(userKey: userKey, menu: group)

        let naviVC = UINavigationController(rootViewController: transiteVC)
//        viewController.navigationController?.pushViewController(naviVC, animated: true)
        viewController.present(naviVC, animated: true, completion: nil)
    }

}
