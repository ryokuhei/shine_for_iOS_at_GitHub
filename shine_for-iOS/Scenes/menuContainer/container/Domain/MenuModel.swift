//
//  UserListModel.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/16.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

class MenuModel {
    
    var index: Int
    var key: String
    var tabDisplay: String?

    init(index: Int, key: String, tabDisplay: String) {
        self.index = index
        self.key = key
        self.tabDisplay = tabDisplay
    }
    
}

extension MenuModel: Equatable {
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        return lhs.index == rhs.index && lhs.key == rhs.key && lhs.tabDisplay == rhs.tabDisplay
    }
    

}
