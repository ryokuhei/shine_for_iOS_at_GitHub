//
//  UserEntity.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/26.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserProfileEntity {
    
    let key: String
    let id: String
    let name: String
    let email: String
    let comment: String?
    let iconFileName: String?
    let group: Group

    init(key: String, id: String, name: String, email: String, comment: String? = nil, iconFileName: String? = nil, group: Group = .none) {
        self.key = key
        self.id = id
        self.name = name
        self.email = email
        self.comment = comment
        self.iconFileName = iconFileName
        self.group = group
    }
    
    init(snapshot: DataSnapshot) {
        self.key = snapshot.key

        let value = snapshot.value as! [String: Any]
        self.id = value["id"] as! String
        self.name = value["name"] as! String
        self.email = value["email"] as! String
        
        self.comment = value["comment"] as? String
        self.iconFileName = value["icon_file_name"] as? String
        let groupKey = value["group"] as? String
        if let groupKey = groupKey {
            self.group = Group(key: groupKey)
        } else {
            self.group = Group()
        }
    }
    
    func toAnyObject() ->Any {
        return [
            "name": self.name,
            "id": self.id,
            "email": self.email,
            "comment": self.comment ?? "",
            "icon_file_name": self.iconFileName ?? "",
            "group": self.group.byKey()
        ]
    }
    
}
