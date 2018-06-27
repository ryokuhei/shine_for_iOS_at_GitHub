//
//  MenuViewModel.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/21.
//  Copyright © 2018 ryoku. All rights reserved.
//
import Foundation

struct MenuListViewModel {
    
    let menuList: [MenuModel]
    var index: Int = 0
    let isInfinite = false
    
    func getCurrentMenu() ->MenuModel? {
        
        var menu: MenuModel? = nil
        if 0 < menuList.count && menuList.count > index {
            menu = menuList[self.index]
        }

        return menu
    }

    func getPreviousMenu() ->MenuModel? {
        
        var menu: MenuModel? = nil
        if hasPrevious() {
            menu = menuList[index - 1]
        } else if self.isInfinite && menuList.count >= 1 {
            menu = menuList.last
        }
        
        return menu
    }
    
    func getNextMenu() ->MenuModel? {
        
        var menu: MenuModel? = nil
        if hasNext() {
            menu = menuList[index + 1]
        } else if self.isInfinite && menuList.count >= 1 {
            menu = menuList.first
        }
        
        return menu
    }
    
    private func hasPrevious() ->Bool {
        return index - 1 >=  0
    }
    
    private func hasNext() ->Bool {
        return index + 1 <= menuList.count - 1
    }
}
