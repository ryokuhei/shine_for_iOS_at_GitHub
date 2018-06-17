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

protocol MenuContainerUseCase {
    func getGroupList() ->Observable<[MenuModel]> 
}

class MenuContainerUseCaseImpl: BaseUseCase, MenuContainerUseCase {
    
    var group: GroupRepository
    var menuTranslator: MenuTranslator
    
    init(group: GroupRepository, menuTranslator: MenuTranslator) {
        self.group = group
        self.menuTranslator = menuTranslator
    }
    
    func getGroupList() ->Observable<[MenuModel]> {
        return group.getGroupList()
                    .map {
                      [unowned self] (groupEntityList) in
                        return groupEntityList.map {
                          [unowned self] (userEntity) in
                            return self.menuTranslator.translate(userEntity)
                        }
                    }
        
    }

}
