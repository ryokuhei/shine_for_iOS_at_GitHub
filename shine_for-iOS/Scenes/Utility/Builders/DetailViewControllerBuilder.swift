//
//  DetailViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class DetailViewControllerBuilder: ViewControllerBuildable {
    
    typealias ViewController = DetailViewController
    
    static func build() -> DetailViewController {
        let storyboard = UIStoryboard(name: "detail", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! DetailViewController
        return vc
    }
    
    static func build(userKey: String, menu group: Group) -> DetailViewController {
        let storyboard = UIStoryboard(name: "detail", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! DetailViewController
        
        let userRepository = UserRepositoryImpl(
            userProfile: FBUserProfileDataStoreImpl(),
            userGroup: FBUserGroupDataStoreImpl()
        )
        let iconRepository = IconRepositoryImpl(
            icon: FBIconDataStoreImpl()
        )
        
        let presenter = DetailPresenterImpl(
            usecase: DetailUseCaseImpl(
                user: userRepository,
                icon: iconRepository,
                translator: UserTranslatorImpl()
            )
        )
        
        let wireframe = DetailWireFrame(viewController: vc)
        
        vc.inject(userKey: userKey, menu: group, presenter: presenter, wireframe: wireframe)
        
        return vc
    }
    
}
