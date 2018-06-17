//
//  SlideMenuView.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/23.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class SlideMenuView: UIView {
    @IBInspectable var borderWidth: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = UIColor.SlideMenu.border.cgColor
        self.backgroundColor = UIColor.SlideMenu.backgroud
        
        super.draw(rect)
    }
}
