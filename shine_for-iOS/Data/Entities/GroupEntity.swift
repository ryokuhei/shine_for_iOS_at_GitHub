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
    
    let group: String

    init(group: String) {
        self.group = group
    }
    init(snapshot: DataSnapshot) {
        self.group = snapshot.key
    }
}
