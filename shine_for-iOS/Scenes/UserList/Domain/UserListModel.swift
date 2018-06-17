//
//  UserListModel.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

class UserListModel {
    var key: String
    var name: String
    var iconPath: String?
    
    init(key: String, name: String, iconPath: String? = nil) {
        
        self.key = key
        self.name = name
        self.iconPath = iconPath
    }
}
