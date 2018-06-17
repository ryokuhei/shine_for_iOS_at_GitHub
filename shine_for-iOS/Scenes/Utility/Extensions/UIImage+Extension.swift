//
//  UIImage+Extension.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/05/15.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func resize(size: CGSize) ->UIImage? {
        
        let widthRatio  = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        let resizeSize = CGSize(width: self.size.width * ratio, height: self.size.height / ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizeSize))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
    
}
