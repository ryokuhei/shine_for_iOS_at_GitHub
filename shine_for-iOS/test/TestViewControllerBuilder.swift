//
//  TestViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/19.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class TestViewControllerBuilder: ViewControllerBuildable {
    
    typealias ViewController = TestViewController
    
    static func build() -> TestViewController {
        let storyboard = UIStoryboard(name: "test", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! TestViewController
        
        return vc
    }
}
