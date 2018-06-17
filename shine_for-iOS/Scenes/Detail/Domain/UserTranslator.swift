//
//  UserModelTranslator.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

protocol UserTranslator {
    func translate(entity: UserProfileEntity) ->UserModel
    func translate(model: UserModel) ->UserProfileEntity
}
class UserTranslatorImpl: BasePresetner, UserTranslator {

    func translate(entity: UserProfileEntity) ->UserModel {
        return UserModel(key: entity.key,
                         id: entity.id,
                         name: entity.name,
                         email: entity.email,
                         comment: entity.comment,
                         iconFileName: entity.iconFileName,
                         group: entity.group)
    }
    
    func translate(model: UserModel) ->UserProfileEntity {
        return UserProfileEntity(key: model.key,
                                 id: model.id,
                                 name: model.name,
                                 email: model.email,
                                 comment: model.comment,
                                 iconFileName: model.iconFileName,
                                 group: model.group
        )
        
    }
}
