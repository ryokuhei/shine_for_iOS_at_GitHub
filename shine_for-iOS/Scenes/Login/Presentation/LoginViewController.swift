//
//  LoginViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func gotoButtonTouch(_ sender: Any) {
        wireframe.showTopViewController()
    }
    
    var wireframe: LoginWireFrame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(wireframe: LoginWireFrame) {
        self.wireframe = wireframe
    }

}
