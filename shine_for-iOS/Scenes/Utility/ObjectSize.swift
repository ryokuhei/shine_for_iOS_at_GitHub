//
//  ObjectSize.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/05/15.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

enum ObjectSize {
    case icon
    
    func size() ->CGSize {
        switch  self {
        case .icon:
            return CGSize(width: 240, height: 240)
        }
    }
}
