//
//  TestPresenter.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/20.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

//class TestPresenter: MenuContainerPresenter, MenuContainerInputs, MenuContainerOutputs {
//
//    var selectMenu = Variable<Int>(0)
//    var swipeOfLeft = PublishSubject<Void>()
//    var swipeOfRight = PublishSubject<Void>()
//
//    lazy var contentIndexOfCurrent: Observable<Int> = {
//        return self.swipeOfLeft.asObserver()
//            .flatMap{_ in self.selectMenu.asObservable()}
//    }()
//
//    lazy var contentIndexOfBefore: Observable<Int> = {
//        return self.swipeOfLeft.asObserver()
//            .flatMap{_ in self.selectMenu.asObservable()}
//    }()
//
//    lazy var contentIndexOfAfter: Observable<Int> = {
//        return self.swipeOfLeft.asObserver()
//            .flatMap{_ in self.selectMenu.asObservable() }
//    }()
//
//    lazy var selectMenuBar: Observable<Int> = {
//        return selectMenu.asObservable()
//    }()
//

//    var menuList: [MenuModel] = []
//
//    lazy var inputs: MenuContainerInputs = {self}()
//    lazy var outputs: MenuContainerOutputs = {self}()
//}
