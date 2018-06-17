//
//  UserGroupEntity.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/30.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserGroupEntity {
    
    let group: String
    var users: [(key: String, name: String)]
    
    init(group: String, users: [(key: String, name: String)]) {
        self.group = group
        self.users = users
    }
    
    init(snapshot: DataSnapshot) {
        
        self.group = snapshot.key

        self.users = []
        
        let children = snapshot.children
        while let userSnapshot = children.nextObject() as? DataSnapshot {
            let key = userSnapshot.key
            if let userValue = userSnapshot.value as? [String: Any] {
                let name = userValue["name"] as! String
                self.users.append((key: key, name: name))
            }
        }
    }
}
