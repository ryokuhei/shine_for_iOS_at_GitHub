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
        
        let repository = UserRepositoryImpl(
            userProfile: FBUserProfileDataStoreImpl(),
            userGroup: FBUserGroupDataStoreImpl()
        )
        let presenter = AddUserPresenterImpl(
            usecase: AddUserUseCaseImpl(
                repository: repository,
                translator: UserTranslatorImpl()
            )
        )
        
        vc.inject(wireframe: wireframe, presenter: presenter)
        
        return vc
    }
    
}

