//
//  LaunchViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.shared.rootViewController.showLoginViewController()
        
    }
}
