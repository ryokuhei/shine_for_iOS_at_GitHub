//
//  UserListPresenter.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/26.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol UserListInputs {
    var selectUserList: PublishSubject<Group>{get}
    var tapUserCell: PublishSubject<String> {get}
}

protocol UserListOutputs {
    var reloadUserList: Observable<[UserListModel]> {get}
    var showUserDetail: Observable<String> {get}
}

protocol UserListPresenter {
    var inputs: UserListInputs {get}
    var outputs: UserListOutputs {get}
}

class UserListPresenterImpl: UserListPresenter, UserListInputs, UserListOutputs {
    
    lazy var inputs: UserListInputs = { self }()
    lazy var outputs: UserListOutputs = { self }()
    
    var usecase: UserListUseCase
    
    init(usercase: UserListUseCase) {
        self.usecase = usercase
    }

    var selectUserList = PublishSubject<Group>()
    var tapUserCell = PublishSubject<String>()
    
    lazy var reloadUserList: Observable<[UserListModel]> = {
        return selectUserList
               .flatMap { [unowned self] searchKey in
            return self.usecase.getUserList(by: searchKey)
        }
    }()
    
    lazy var showUserDetail: Observable<String> = {
        return tapUserCell
    }()
}
