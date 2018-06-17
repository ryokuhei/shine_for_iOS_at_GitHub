//
//  EditWireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/31.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

class EditWireFrame: WireFrame {
    typealias ViewController = EditViewController
    
    let viewController: EditViewController
    
    required init(viewController: EditViewController) {
        self.viewController = viewController
    }
    
    func showDetailViewController() {
        viewController.navigationController?.popViewController(animated: true)

    }
}
