//
//  File.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/31.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol MenuContainerUseCase {
    func getGroupList() ->Observable<[MenuModel]>
    func instantiateViewController(at menu: MenuModel) ->Observable<UIViewController>
}

class MenuContainerUseCaseImpl: BaseUseCase, MenuContainerUseCase {
    
    var group: GroupRepository
    var menuTranslator: MenuTranslator
    
    init(group: GroupRepository, menuTranslator: MenuTranslator) {
        self.group = group
        self.menuTranslator = menuTranslator
    }
    
    func getGroupList() ->Observable<[MenuModel]> {
        var index = -1
        return group.getGroupList()
                    .map {
                      [unowned self] (groupEntityList) in
                        return groupEntityList.map {
                            
                          [unowned self] (userEntity) in
                            index = index + 1
                            return self.menuTranslator.translate(index: index, userEntity)
                        }
                    }
        
    }
    
    func instantiateViewController(at menu: MenuModel) ->Observable<UIViewController> {
        return Observable.just(UserListViewControllerBuilder.build(menu.key))
    }

}
