//
//  UserListTranslator.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

protocol UserListTranslator {
    
    func translate(_ userGroupEntity: UserGroupEntity) ->[UserListModel]
}

class UserListTranslatorImpl: BaseTranslator, UserListTranslator {
    
    func translate(_ userGroupEntity: UserGroupEntity) ->[UserListModel] {
        
        let users = userGroupEntity.users
        return users.map { user in
            UserListModel(key: user.key, name: user.name)
        }
    }
    
}
