//
//  MenuContainerPresenter2.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/18.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol MenuContainerInputs2 {
    
    var selectedMenus: PublishSubject<(prev: MenuModel?, current: MenuModel, next: MenuModel?)> {get}
    
    var pushOutMenuFromBefore: PublishSubject<MenuModel?> {get}
    var pushOutMenuFromAfter: PublishSubject<MenuModel?> {get}

    var swipedLeftWithIndex: PublishSubject<Int> {get}
    var swipedRightWithIndex: PublishSubject<Int> {get}
}

protocol MenuContainerOutputs2 {
    
    var currentMenu: Observable<MenuModel> {get}
    var afterMenu: Observable<MenuModel?> {get}
    var beforeMenu: Observable<MenuModel?> {get}
    
    var selectedMenu: Observable<MenuModel> {get}
    
    var pushOutMenuFromBefore: PublishSubject<MenuModel?> {get}
    var pushOutMenuFromAfter: PublishSubject<MenuModel?> {get}

    var swipedLeftWithIndex: PublishSubject<Int> {get}
    var swipedRightWithIndex: PublishSubject<Int> {get}

//    var setContentViewControllers: Observable<(beforeVC: UIViewController?, currentVC: UIViewController, afterVC: UIViewController?)> {get}
}

protocol MenuContainerPresenter2 {
    
    var inputs: MenuContainerInputs2 {get}
    var outputs: MenuContainerOutputs2 {get}
}

class MenuContainerPresenterImpl2: MenuContainerPresenter2, MenuContainerInputs2, MenuContainerOutputs2 {

    private var usecase: MenuContainerUseCase

    lazy var inputs: MenuContainerInputs2 = {self}()
    lazy var outputs: MenuContainerOutputs2 = {self}()

    var selectedMenus = PublishSubject<(prev: MenuModel?, current: MenuModel, next: MenuModel?)>()
    var pushOutMenuFromBefore = PublishSubject<MenuModel?>()
    var pushOutMenuFromAfter = PublishSubject<MenuModel?>()

    var swipedLeftWithIndex = PublishSubject<Int>()
    var swipedRightWithIndex = PublishSubject<Int>()

    lazy var beforeMenu: Observable<MenuModel?> = {
        return selectedMenus.map { menus in return menus.prev }
    }()
    lazy var currentMenu: Observable<MenuModel> = {
        return selectedMenus.map { menus in return menus.current }
    }()
    lazy var afterMenu: Observable<MenuModel?> = {
        return selectedMenus.map { menus in return menus.next }
    }()

    lazy var selectedMenu: Observable<MenuModel> = {
        return selectedMenus.map { menus in return menus.current }
    }()
    
    init(usecase: MenuContainerUseCase) {
        self.usecase = usecase
    }
}
