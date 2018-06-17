//
//  UserListPageViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/13.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class MenuContainerViewControllerBuilder: ViewControllerBuildable {
    
    typealias ViewController = MenuContainerViewController

    static func build() -> MenuContainerViewController {
        let storyboard = UIStoryboard(name: "menuContainer", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MenuContainerViewController
        
        let repository = GroupRepositoryImpl(
            group: FBGroupDataStoreImpl()
        )
        let presenter = MenuContainerPresenterImpl(
            usecase: MenuContainerUseCaseImpl(
                group: repository,
                menuTranslator: MenuTranslatorImpl()
            )
        )
        vc.inject(presenter: presenter)
        
        return vc
    }
    
}

