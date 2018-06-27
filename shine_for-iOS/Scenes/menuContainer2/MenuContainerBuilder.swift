//
//  C.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/21.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

struct MenuContainerBuilder {
    
    typealias ViewController = MenuContainerViewController2
    
    static func build() -> MenuContainerViewController2 {

        let storyboard = UIStoryboard(name: "menuContainer", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MenuContainerViewController2
        
        let groupRepository = GroupRepositoryImpl(group: FBGroupDataStoreImpl())
        let menuTrannslator = MenuTranslatorImpl()
        
        let menuContentPresenter = MenuContainerPresenterImpl2(usecase: MenuContainerUseCaseImpl(
                                                                   group: groupRepository,
                                                                   menuTranslator: menuTrannslator
                                                                   )
                                                               )
        let menuBarPresenter = MenuBarPresenterImpl2(translator: menuTrannslator,
                                                     group: GroupRepositoryImpl(
                                                        group: FBGroupDataStoreImpl()
                                                     ),
                                                     isInfinite: true)
        
        vc.inject(menuContentPresenter: menuContentPresenter,
                  menuBarPresenter: menuBarPresenter,
                  contentPageVC: self.contentPageBuilder())
        
        return vc
    }
    
    static private func contentPageBuilder() ->MenuContentPageViewController2 {
        
        let storyboard = UIStoryboard(name: "menuContentPage", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MenuContentPageViewController2
        
        return vc
    }
}
