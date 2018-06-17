//
//  DetailWireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

class DetailWireFrame: WireFrame {
    typealias ViewController = DetailViewController
    
    let viewController: DetailViewController
    
    required init(viewController: DetailViewController) {
        self.viewController = viewController
    }
    
    func showEditViewController(user: UserModel, icon: Data? = nil) {
        let transiteVC = EditViewControlerBuilder.build(user: user, icon: icon)
        viewController.navigationController?.pushViewController(transiteVC, animated: true)
    }
    
    func dismissViewController() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
