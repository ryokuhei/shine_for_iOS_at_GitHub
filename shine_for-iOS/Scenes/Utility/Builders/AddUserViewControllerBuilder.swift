//
//  AddUserViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class AddUserViewControlerBuilder: ViewControllerBuildable {
    
    typealias ViewController = AddUserViewController
    
    static func build() -> AddUserViewController {
        let storyboard = UIStoryboard(name: "addUser", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! AddUserViewController
        
        let wireframe = AddUserWireFrame(viewController: vc)
        
        let userRepository = UserRepositoryImpl(
            userProfile: FBUserProfileDataStoreImpl(),
            userGroup: FBUserGroupDataStoreImpl()
        )
        let iconRepository = IconRepositoryImpl(icon: FBIconDataStoreImpl())
        let groupRepository = GroupRepositoryImpl(group: FBGroupDataStoreImpl())
        let presenter = AddUserPresenterImpl(
            usecase: AddUserUseCaseImpl(
                userRepository: userRepository,
                iconRepository: iconRepository,
                groupRepository: groupRepository,
                translator: UserTranslatorImpl()
            )
        )
        
        vc.inject(wireframe: wireframe, presenter: presenter)
        
        return vc
    }
    
}

