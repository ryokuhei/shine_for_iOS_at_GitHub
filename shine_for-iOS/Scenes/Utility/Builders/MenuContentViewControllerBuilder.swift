//
//  MenuContentViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/17.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class MenuContentViewContorllerBuilder: ViewControllerBuildable {
    
    typealias ViewController = MenuContentViewContorller

    static func build() -> MenuContentViewContorller {
        let storyboard = UIStoryboard(name: "menuContent", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MenuContentViewContorller

        return vc
    }

    static func build(menu: MenuModel) -> MenuContentViewContorller {
        let storyboard = UIStoryboard(name: "menuContent", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MenuContentViewContorller

        let wireframe = MenuWireFrame(viewController: vc)

        vc.inject(menu: menu, wireframe: wireframe)

        return vc
    }
    
//    typealias ViewController = UserListViewController
//
//    static func build() -> UserListViewController {
//        let storyboard = UIStoryboard(name: "userList", bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! UserListViewController
//
//        return vc
//    }
//
//    static func build(index: Int) -> UserListViewController {
//        let vc = UserListViewControllerBuilder.build(index: index)

//        return vc
//    }
}
