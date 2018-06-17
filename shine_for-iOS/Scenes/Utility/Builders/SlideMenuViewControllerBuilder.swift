//
//  SideMenuViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/05.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class SlideMenuViewControllerBuilder: ViewControllerBuildable {
    
    typealias ViewController = SlideMenuViewController

    static func build() -> ViewController {
        let storyboard = UIStoryboard(name: "slideMenu", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! SlideMenuViewController
        
        let presenter = SlideMenuPresenterImpl()
        let wireframe = SlideMenuWireFrame(viewController: vc)
        
        vc.inject(presenter, wireframe)

        return vc
    }
    
}


