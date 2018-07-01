//
//  UserModel.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

class UserModel: BaseModel {
    
    var key: String
    var id: String
    var name: String
    var email: String
    var comment: String?
    var icon: Data?
    var iconFileName: String?
    var menu: Group

    init(key: String,
         id: String,
         name: String,
         email: String,
         comment: String? = nil,
         icon: Data? = nil,
         iconFileName: String? = nil,
         menu: Group = .none ) {
        
        self.key = key
        self.id = id
        self.name = name
        self.email = email
        self.comment = comment
        self.icon = icon
        self.iconFileName = iconFileName
        self.menu = menu
    }
    
}
