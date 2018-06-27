//
//  MenuContentPageBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/21.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

struct MenuContantPageBuilder: ViewControllerBuildable {

    typealias ViewController = MenuContentPageViewController2
    
    static func build() -> MenuContentPageViewController2 {
        
        let storyboard = UIStoryboard(name: "page", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MenuContentPageViewController2
        
        return vc
    }
}
