//
//  MenuTranslator.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/31.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

protocol MenuTranslator {
    func translate(_ groupEntity: GroupEntity) ->MenuModel
}

class MenuTranslatorImpl: BaseTranslator, MenuTranslator {
    
    func translate(_ groupEntity: GroupEntity) ->MenuModel {
        return MenuModel(key: groupEntity.group, tabDisplay: groupEntity.group)
    }
    
}
