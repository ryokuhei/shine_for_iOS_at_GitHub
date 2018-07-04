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
        let resizeSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizeSize))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
    
    func compressCapacityToAbout(megabyte capacity: Int) ->UIImage? {
        guard let imageData = UIImagePNGRepresentation(self) else {
            return nil
        }
        let imageSize = imageData.count / 1024
        let percent = CGFloat(Double(imageSize / (capacity * 1024)) / 100.0)
        
        guard let compressedImage = self.resize(size: CGSize(width: size.width * percent, height: size.height * percent)) else {return nil}
        return compressedImage
    }
    
}

