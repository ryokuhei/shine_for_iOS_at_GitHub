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
    var group: Group
    var tabDisplay: String?

    init(index: Int, group: Group, tabDisplay: String) {
        self.index = index
        self.group = group
        self.tabDisplay = tabDisplay
    }
    
}

extension MenuModel: Equatable {
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        return lhs.index == rhs.index && lhs.group == rhs.group && lhs.tabDisplay == rhs.tabDisplay
    }
    

}
