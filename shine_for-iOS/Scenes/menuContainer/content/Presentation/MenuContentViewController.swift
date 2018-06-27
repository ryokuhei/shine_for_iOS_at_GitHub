//
//  MenuContantViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/17.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class MenuContentViewContorller: UIViewController {
    
    var menu: MenuModel?
    var wireframe: MenuWireFrame?

    func inject(menu: MenuModel, wireframe: MenuWireFrame) {
        self.menu = menu
        self.wireframe = wireframe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let key = self.menu?.key {
            wireframe?.showContentView(key: key)
        }
    }
    
}
