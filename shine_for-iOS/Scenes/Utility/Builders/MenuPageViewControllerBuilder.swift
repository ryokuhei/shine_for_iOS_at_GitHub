//
//  MenuPageViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/17.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class MenuPageViewControllerBuilder: ViewControllerBuildable {
    
    typealias ViewController = MenuPageViewController
    
    static func build() -> MenuPageViewController {
        let storyboard = UIStoryboard(name: "menuPage", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MenuPageViewController
        
//        let presenter = MenuContainerPresenterImpl()
//        vc.inject(presenter: presenter)
        
        return vc
    }
    
}
