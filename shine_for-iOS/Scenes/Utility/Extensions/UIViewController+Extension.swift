//
//  UIViewController+Extension.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/04.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double
        
        UIView.animate(withDuration: duration ?? 0.0, animations: {
            let tranform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = tranform
        })

    }
    
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?["UIKeyboardAnimationCurveUserInfoKey"] as? Double
        UIView.animate(withDuration: duration ?? 0.0, animations: {
            self.view.transform = CGAffineTransform.identity
        })

    }
    
}
