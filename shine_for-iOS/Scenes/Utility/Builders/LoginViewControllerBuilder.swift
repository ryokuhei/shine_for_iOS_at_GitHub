//
//  LoginViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class LoginViewControllerBuilder: ViewControllerBuildable {
    
    typealias ViewController = LoginViewController
    
    static func build() -> ViewController {
        let storyboard = UIStoryboard(name: "login", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! LoginViewController
        
        let wirefram = LoginWireFrame(viewController: vc)
        vc.inject(wireframe: wirefram)
        
        return vc
    }
}
