//
//  ViewControllerBuildable.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerBuildable {
    
    associatedtype ViewController = UIViewController
    
    static func build() ->ViewController
}
