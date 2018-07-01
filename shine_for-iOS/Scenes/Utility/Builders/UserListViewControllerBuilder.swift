//
//  UserListViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/05.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class UserListViewControllerBuilder: ViewControllerBuildable {

    typealias ViewController = UserListViewController
    
    static func build() -> UserListViewController {
        let storyboard = UIStoryboard(name: "userList", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UserListViewController
        let wireFrame = UserListWireFrame(viewController: vc)
        
        let repository = UserRepositoryImpl(
            userProfile: FBUserProfileDataStoreImpl(),
            userGroup: FBUserGroupDataStoreImpl()
        )
        let usecase = UserListUseCaseImpl(
            user: repository,
            userListTranslator: UserListTranslatorImpl()
        )
        let presenter = UserListPresenterImpl(usercase: usecase)
        
        let group = MenuManager.menuList[0].group
        vc.inject(group: group, wireFrame: wireFrame, presenter: presenter)
        
        return vc
    }
    
    static func build(_ group: Group) -> UserListViewController {
        
        let storyboard = UIStoryboard(name: "userList", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UserListViewController
        let wireFrame = UserListWireFrame(viewController: vc)
        
        let repository = UserRepositoryImpl(
            userProfile: FBUserProfileDataStoreImpl(),
            userGroup: FBUserGroupDataStoreImpl()
        )
        
        let presenter = UserListPresenterImpl(
            usercase: UserListUseCaseImpl(user: repository,
                                          userListTranslator: UserListTranslatorImpl()
            )
        )
        
        vc.inject(group: group, wireFrame: wireFrame, presenter: presenter)
        
        return vc
    }
}
