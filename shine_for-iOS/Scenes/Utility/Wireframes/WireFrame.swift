//
//  WireFrame.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/06.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

protocol WireFrame {
    
    associatedtype ViewController: UIViewController
    
    init(viewController: ViewController)
    
}
