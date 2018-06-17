//
//  SplashViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class SplashViewControllerBuilder: ViewControllerBuildable {

    typealias ViewController = SplashViewController
    
    static func build() -> ViewController {
        let storyboard = UIStoryboard(name: "splash", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! SplashViewController
        
        return vc
    }
    
}
