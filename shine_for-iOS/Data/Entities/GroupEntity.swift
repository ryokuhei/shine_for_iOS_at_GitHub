//
//  GroupEntity.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/29.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GroupEntity {
    
    let group: Group
    let isUsed: Bool

    init(group: Group, isUsed: Bool = false) {
        self.group = group
        self.isUsed = isUsed
    }
    init(snapshot: DataSnapshot) {
        self.group = Group(key: snapshot.key)
        guard let value = snapshot.value as? [String: Any]  else {
            self.isUsed = false
            return
        }
        self.isUsed = value[self.group.byKey()] as? Bool ?? false
    }
}
