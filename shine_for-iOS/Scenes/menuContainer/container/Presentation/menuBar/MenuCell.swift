//
//  FirstCharacterCell.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/11.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UICollectionViewCell {
    
    @IBOutlet weak var menuView: UILabel!
    
    func setDisplay(display: String) {
        menuView.text = display
    }
}
