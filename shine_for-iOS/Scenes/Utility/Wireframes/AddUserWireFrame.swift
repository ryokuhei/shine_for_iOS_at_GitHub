//
//  AddUserWireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

class AddUserWireFrame: WireFrame {
    typealias ViewController = AddUserViewController
    
    let viewController: AddUserViewController
    
    required init(viewController: AddUserViewController) {
        self.viewController = viewController
    }
    
    func showTopView() {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
