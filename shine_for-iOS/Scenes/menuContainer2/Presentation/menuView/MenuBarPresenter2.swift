//
//  MenuBarPresenter2.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/20.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuBarInputs2 {
    var menuList: [MenuModel] {get}
    var indexOfSelected: PublishSubject<Int> {get}
    var indexOfLeftSwiped: PublishSubject<Int> {get}
    var indexOfRightSwiped: PublishSubject<Int> {get}
    
    var reload: PublishSubject<Void> {get}

    func reloadMenu()
}
protocol MenuBarOutputs2 {
    
    var menuList: [MenuModel] {get}
    
    var selectedMenus: Observable<(prev: MenuModel?, current: MenuModel, next: MenuModel?)> {get}
    var eventOfLeftSwiped: Observable<Int> {get}
    var eventOfRightSwiped: Observable<Int> {get}
    
    var pushOutMenuFromBefore: Observable<MenuModel?> {get}
    var pushOutMenuFromAfter: Observable<MenuModel?> {get}
    
    var reloadData: Observable<Void> {get}

    var isInfinite: Bool {get}
}

protocol MenuBarPresenter2 {
    var inputs: MenuBarInputs2 {get}
    var outputs: MenuBarOutputs2 {get}
}

class MenuBarPresenterImpl2: MenuBarPresenter2, MenuBarInputs2, MenuBarOutputs2 {

    lazy var inputs: MenuBarInputs2 = {self}()
    lazy var outputs: MenuBarOutputs2 = {self}()
    
    var menuList: [MenuModel] = []
    var disposeBag = DisposeBag()
    
    var indexOfSelected = PublishSubject<Int>()
    var indexOfLeftSwiped = PublishSubject<Int>()
    var indexOfRightSwiped = PublishSubject<Int>()
    
    var reload = PublishSubject<Void>()
    
    lazy var selectedMenus: Observable<(prev: MenuModel?, current: MenuModel, next: MenuModel?)> = {
        return indexOfSelected
            .map( { [unowned self] index in
                var prevMenu: MenuModel?
                var nextMenu: MenuModel?
                if let prevIndex = self.indexSefetyInMenuList(index - 1) {
                    prevMenu = self.menuList[prevIndex]
                }
                if let nextIndex = self.indexSefetyInMenuList(index + 1) {
                    nextMenu = self.menuList[nextIndex]
                }
                return (prev: prevMenu, current: self.menuList[index], next: nextMenu)
            })
    }()
    
    lazy var eventOfLeftSwiped: Observable<Int> = {
        return indexOfLeftSwiped

    }()
    
    lazy var eventOfRightSwiped: Observable<Int> = {
        return indexOfRightSwiped
    }()
    
    lazy var pushOutMenuFromBefore: Observable<MenuModel?> = {
        return self.indexOfRightSwiped
            .map { [unowned self] index in
                var menu: MenuModel?
                if let prevIndex = self.indexSefetyInMenuList(index - 1) {
                    menu = self.menuList[prevIndex]
                }
                return menu
            }
    }()
    
    lazy var pushOutMenuFromAfter: Observable<MenuModel?> = {
        return self.indexOfLeftSwiped
            .map { [unowned self] index in
                var menu: MenuModel?
                if let nextIndex = self.indexSefetyInMenuList(index + 1) {
                    menu = self.menuList[nextIndex]
                }
                return menu
        }
    }()
    
    lazy var reloadData: Observable<Void> = {
        return reload
    }()

    var isInfinite: Bool

    var group :GroupRepository
    var translator: MenuTranslator
    
    init(translator: MenuTranslator, group: GroupRepository, isInfinite: Bool = false) {
        
        self.translator = translator
        self.group = group
        
        self.isInfinite = isInfinite
        
        self.reloadMenu()
    }

    func reloadMenu() {
        print("reloadMenu")
        var index = -1
        self.group.getGroupList()
            .map {
                (groupList) ->[MenuModel] in
                return groupList.map {
                    (groupEntity) ->MenuModel in
                    index = index + 1
                    return self.translator.translate(index: index, groupEntity)
                }
            }
            .subscribe(onNext: {
                [unowned self] menuList in
                let countOfOldMenu = self.menuList.count
                self.menuList = menuList
                self.reload.onNext(())
                
                if countOfOldMenu <= 0 && menuList.count >= 1 {
                    self.indexOfSelected.onNext(0)
                }

            })
            .disposed(by: disposeBag)
    }
    
    private func indexSefetyInMenuList(_ selectIndex: Int) ->Int? {
        
        var index: Int?
        
        if self.menuList.count != 0 && 0 <= selectIndex && selectIndex < self.menuList.count {
            index = selectIndex
        }
        return index
    }
    
}
