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
    
    var index: Int = 0
    var wireframe: MenuWireFrame?

    func inject(index: Int, wireframe: MenuWireFrame) {
        self.index = index
        self.wireframe = wireframe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wireframe?.showContentView(index: self.index)
    }
    
}
