//
//  EditViewControllerBuilder.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class EditViewControlerBuilder: ViewControllerBuildable {
    
    typealias ViewController = EditViewController
    
    // dupulicate
    static func build() -> EditViewController {
        let storyboard = UIStoryboard(name: "edit", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! EditViewController
        
        return vc
    }
    
    static func build(user model: UserModel, icon: Data?) -> ViewController {
        let storyboard = UIStoryboard(name: "edit", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! EditViewController
        
        let wireframe = EditWireFrame(viewController: vc)
        
        let userRepository = UserRepositoryImpl(
            userProfile: FBUserProfileDataStoreImpl(),
            userGroup: FBUserGroupDataStoreImpl()
        )
        let iconRepository = IconRepositoryImpl(
            icon: FBIconDataStoreImpl()
        )
        
        let presenter = EditPresenterImpl(
            usecase: EditUseCaseImpl(
                userRepository: userRepository,
                iconRepository: iconRepository,
                translator: UserTranslatorImpl()
            )
        )
        vc.inject(user: model, icon: icon, presenter: presenter, wireframe: wireframe)
        
        return vc
    }
    

}


