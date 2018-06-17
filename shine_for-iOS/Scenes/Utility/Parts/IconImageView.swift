//
//  IconImageView.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/05/16.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class IconImageView: UIImageView {
    
    // corner
    @IBInspectable var cornerRadius: CGFloat = 0.5
    
    // border
    @IBInspectable var borderColor: UIColor = UIColor.Icon.border
    @IBInspectable var borderWidth: CGFloat = 0.1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        
        self.layer.cornerRadius = self.frame.size.width * self.cornerRadius
        self.clipsToBounds = (self.cornerRadius > 0)
        
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.backgroundColor = UIColor.Icon.backgroud.cgColor
        self.layer.borderWidth = self.borderWidth
    }
    
}
