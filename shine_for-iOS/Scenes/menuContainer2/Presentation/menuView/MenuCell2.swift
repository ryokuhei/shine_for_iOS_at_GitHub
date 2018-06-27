//
//  MenuCell.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/19.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class MenuCell2: UICollectionViewCell {
    
    @IBOutlet weak var menuView: UILabel!
    
    func setDisplay(display: String) {
        menuView.text = display
    }
}
