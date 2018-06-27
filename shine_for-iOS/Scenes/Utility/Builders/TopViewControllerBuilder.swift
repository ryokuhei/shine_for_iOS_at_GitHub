//
//  TopViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/05.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class TopViewControllerBuilder: ViewControllerBuildable {
    
    typealias ViewController = TopViewController
    
    static func build() -> ViewController {
        
        let storyboard = UIStoryboard(name: "top", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! TopViewController
        vc.inject(
            wireframe: TopWireFrame(viewController: vc),
            presenter: TopPresenterImpl()
        )
        vc.setViewController(
            slideMenuVC: SlideMenuViewControllerBuilder.build(),
            contentVC: MenuContainerBuilder.build()
        )
        
        return vc
    }
}
