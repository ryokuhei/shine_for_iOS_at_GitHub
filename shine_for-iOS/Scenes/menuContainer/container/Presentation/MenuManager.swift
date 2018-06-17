//
//  UserListMenuManager.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/20.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MenuManager {
    
    static var menuList: [MenuModel] = []
    
    static var disposeBag = DisposeBag()
    
    static var group :GroupRepository = {
        let datastore = FBGroupDataStoreImpl()
        
        return GroupRepositoryImpl(group: datastore)
    }()
    
    static var translator: MenuTranslator = {
        return MenuTranslatorImpl()
    }()

    static func reload() {
        self.group.getGroupList()
            .map {
              (groupList) ->[MenuModel] in
                return groupList.map {
                  (groupEntity) ->MenuModel in
                    return self.translator.translate(groupEntity)
                }
            }
            .subscribe(onNext: {
              menuList in
                self.menuList = menuList
            })
            .disposed(by: disposeBag)
    }

}
