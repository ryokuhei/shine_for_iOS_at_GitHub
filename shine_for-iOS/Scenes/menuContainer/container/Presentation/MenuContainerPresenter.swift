//
//  FirstCharactersMenuBarPresenter.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/11.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol MenuContainerInputs {

    var selectMenu: PublishSubject<MenuModel> { get }
    var swipeOfLeft: PublishSubject<Void> { get }
    var swipeOfRight: PublishSubject<Void> { get }
}

protocol MenuContainerOutputs {
    
    var contentIndexOfCurrent: Observable<Int?>{get}
    var contentIndexOfBefore: Observable<Int?>{get}
    var contentIndexOfAfter: Observable<Int?>{get}
    
    var menuList: Observable<[MenuModel]> {get}
    
    var selectedMenu: Observable<MenuModel>{get}
}

protocol MenuContainerPresenter {
    
    var inputs: MenuContainerInputs { get }
    var outputs: MenuContainerOutputs { get }
}
    
class MenuContainerPresenterImpl: MenuContainerPresenter,MenuContainerInputs, MenuContainerOutputs {

    lazy var inputs: MenuContainerInputs   = { self }()
    lazy var outputs: MenuContainerOutputs = { self }()
    
    var usecase: MenuContainerUseCase
    
    init(usecase: MenuContainerUseCase) {
        self.usecase = usecase
    }
    
    var selectMenu = PublishSubject<MenuModel>()
    
    var swipeOfLeft = PublishSubject<Void>()
    var swipeOfRight = PublishSubject<Void>()

    var index: Int? = nil

    lazy var incrementIndex: Observable<Int> = {
        return swipeOfLeft.asObservable()
                          .map{ [unowned self] index in self.index! + 1 }
                          .share(replay: 1)
    }()
    
    lazy var decrementIndex: Observable<Int> = {
        return self.swipeOfRight
                   .map{ [unowned self] index in self.index! - 1 }
                   .share(replay: 1)
    }()
    
    lazy var currentIndex: Observable<Int?> = {
        return Observable.merge(selectMenu.asObservable()
                                           .map { menu in
                                               return menu.index
                                           },
                                incrementIndex,
                                decrementIndex)
               .flatMap {
                 [unowned self] index in
                   return self.safeOfIndex(index)
               }
               .do(onNext: { index in
                   self.index = index
               })
               .share(replay: 1)
    }()
    
    lazy var contentIndexOfCurrent: Observable<Int?> = {
        return self.currentIndex
               .share(replay: 1)
    }()
    
    lazy var contentIndexOfBefore: Observable<Int?> = {
        return self.currentIndex
                   .filter { $0 != nil }
                   .flatMap {
                     [unowned self] index in
                       return self.safeOfIndex(index! - 1)
                   }
                   .share(replay: 1)
    }()
    
    lazy var contentIndexOfAfter: Observable<Int?> = {
        return self.currentIndex
                   .filter { $0 != nil }
                   .flatMap {
                     [unowned self] index in
                       return self.safeOfIndex(index! + 1)
                   }
                   .share(replay: 1)
    }()
    
    lazy var selectedMenu: Observable<MenuModel> = {
        return self.selectMenu.asObservable()
                   .share(replay: 1)
    }()


    lazy var menuList: Observable<[MenuModel]> = {
        return self.usecase.getGroupList()
    }()

    private func safeOfIndex(_ selectIndex: Int) ->Observable<Int?> {

        return  self.menuList
                    .map {
                      (menuList) in
                        var index = 0
                        if selectIndex < 0 {
                            index = menuList.count - 1
                        } else if selectIndex > menuList.count - 1 {
                            index = 0
                        } else {
                            index = selectIndex
                        }
                        return index
                    }
    }

}
